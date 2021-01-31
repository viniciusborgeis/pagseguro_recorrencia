require 'uri'
require 'net/http'
require 'pagseguro_recorrencia/source/requests/request_application'
require 'pagseguro_recorrencia/source/builds/build_xml'

module PagseguroRecorrencia
  module PagRequests
    class NewPlan < RequestApplication
      def create(payload)
        check_required_payload_presencies(payload, required_params)
        replaced_payload = replace_sensitive_field_with_present(payload)        
        body = PagseguroRecorrencia::Builds::XML.new_plan(replaced_payload)
        do_request(body)
      end

      private

      def do_request(body)
        url = build_environment_url(PagseguroRecorrencia::PagCore.configuration, :new_plan)
        header_accept = 'application/vnd.pagseguro.com.br.v3+xml;charset=ISO-8859-1'
        header_content_type = 'application/xml;charset=ISO-8859-1'
        https, request = build_https_request(url, :post, header_content_type, header_accept).values_at(:https, :request)
        request.body = body

        response = request_safe(https, request)
      end

      def request_safe(https, request)
        response = https.request(request)

        3.times do |_i|
          break if response.code != status_code.not_found

          response = https.request(request)
        end

        parse_response(response)
      end

      def parse_response(response)
        response_code = response.code
        response_msg = response.msg
        if response_code == status_code.ok
          response_body = parse_xml_to_hash(response.read_body)[:pre_approval_request]
        elsif response_code == status_code.bad_request
          response_body = parse_xml_to_hash(response.read_body)[:errors]
        end
        response_body = parse_xml_to_hash(response.read_body) unless %w[200 400]

        {
          code: response_code,
          message: response_msg,
          body: response_body
        }
      end

      def replace_sensitive_field_with_present(payload)
        replaced_payload = check_sensitive_value(payload, :charge_type, charge_type_values)
        replaced_payload = check_sensitive_value(replaced_payload, :period, period_values)
        check_sensitive_value(replaced_payload, :expiration_unit, expiration_unit_values)
      end

      def check_sensitive_value(payload, key, params)
        return payload unless payload.key?(key)

        tmp_payload = payload.dup

        params.map { |value| tmp_payload[key] = value.to_s.upcase if payload[key].to_sym == value }
        if tmp_payload[key] == payload[key]
          received_params = params.map { |param| ":#{param}" }.join(', ')
          raise_message = "[VALUE_ERROR] :#{key} can only receive these values (#{received_params})"
          raise raise_message
        end

        tmp_payload
      end

      def required_params
        %i[
          plan_name
          charge_type
          amount_per_payment
        ]
      end

      def charge_type_values
        %i[manual auto]
      end

      def period_values
        %i[weekly monthly bimonthly trimonthly semiannually yearly]
      end

      def expiration_unit_values
        %i[days months years]
      end
    end
  end
end
