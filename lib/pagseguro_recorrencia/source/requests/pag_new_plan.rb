require 'uri'
require 'net/http'
require 'pagseguro_recorrencia/source/requests/request_application'
require 'pagseguro_recorrencia/source/builds/build_xml'

module PagseguroRecorrencia
  module PagRequests
    class NewPlan < RequestApplication
      def create(payload)
        check_required_payload_presencies(payload, parameters(:required))

        replaced_payload = replace_sensitive_field_with_present(payload)
        body = PagseguroRecorrencia::Builds::XML.new_plan(replaced_payload)
        url = url_environment(PagseguroRecorrencia::PagCore.configuration, :new_plan)
        header = { accept: header_accept, content_type: header_content_type }

        https, request = request_https(url, :post, header).values_at(:https, :request)
        request.body = body

        response = request_safe(https, request)
        parse_response(response)
      end

      private

      def parse_response(response)
        response_code = response.code
        response_msg = response.msg

        if [STATUS_CODE.not_found].include?(response_code)
          response_body = nil
        elsif [STATUS_CODE.ok].include?(response_code) 
          response_body = parse_xml_to_hash(response.read_body)[:pre_approval_request]
        elsif [STATUS_CODE.bad_request].include?(response_code)
          response_body = parse_xml_to_hash(response.read_body)[:errors]
        else
          response_body = response.read_body
        end

        {
          code: response_code,
          message: response_msg,
          body: response_body
        }
      end

      def replace_sensitive_field_with_present(payload)
        replaced_payload = check_sensitive_value(payload, :charge_type, parameters(:charge_type))
        replaced_payload = check_sensitive_value(replaced_payload, :period, parameters(:period_values))
        check_sensitive_value(replaced_payload, :expiration_unit, parameters(:expiration_unit_values))
      end

      def check_sensitive_value(payload, key, params)
        return payload unless payload.key?(key)

        tmp_payload = payload.dup

        params.map do |value|
          if payload[key].to_sym == value
            tmp_payload[key] = value.to_s.upcase
          end
        end

        if tmp_payload[key] == payload[key]
          received_params = params.map { |param| ":#{param}" }.join(', ')
          raise_value_error(key, received_params)
        end

        tmp_payload
      end

      def parameters(type)
        return %i[plan_name charge_type amount_per_payment] if %i[required].include?(type)
        return %i[manual auto] if %i[charge_type].include?(type)
        return %i[weekly monthly bimonthly trimonthly semiannually yearly] if %i[period_values].include?(type)
        return %i[days months years] if %i[expiration_unit_values].include?(type)
      end

    end
  end
end
