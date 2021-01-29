require 'uri'
require 'net/http'
require 'pagseguro_recorrencia/source/core/pag_core'
require 'pagseguro_recorrencia/source/requests/request_application'

module PagseguroRecorrencia
  module PagRequests
    class NewSession < RequestApplication
      def create
        url = build_environment_url(PagseguroRecorrencia::PagCore.configuration,:new_session)
        header_content_type = 'application/x-www-form-urlencoded'
        https, request = build_https_request(url, :post, header_content_type).values_at(:https, :request)
        response = request_safe(https, request)
        define_session_id(response[:body][:session][:id]) if response[:body].key?(:session)

        response
      end

      private

      def request_safe(https, request)
        response = https.request(request)

        3.times do |_i|
          response = https.request(request)
          break if response.code != status_code.not_found
        end

        parse_response(response)
      end

      def parse_response(response)
        response_code = response.code
        response_msg = response.msg
        response_body = parse_xml_to_hash(response.read_body) if response_code == status_code.ok
        response_body = response.read_body if response_code == status_code.unauthorized
        response_body = parse_xml_to_hash(response.read_body) unless response_code == status_code.ok || response_code == status_code.bad_request

        {
          code: response_code,
          message: response_msg,
          body: response_body
        }
      end
    end
  end
end
