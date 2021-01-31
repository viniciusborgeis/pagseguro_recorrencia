require 'uri'
require 'net/http'
require 'pagseguro_recorrencia/source/core/pag_core'
require 'pagseguro_recorrencia/source/requests/request_application'

module PagseguroRecorrencia
  module PagRequests
    class NewSession < RequestApplication
      def create
        url = url_environment(PagseguroRecorrencia::PagCore.configuration, :new_session)
        header = { content_type: header_content_type(:form) }

        https, request = request_https(url, :post, header).values_at(:https, :request)
        
        response = request_safe(https, request)
        parsed_response = parse_response(response)        
        check_to_define_session(parsed_response)

        parsed_response
      end

      private

      def check_to_define_session(response)
        if !response[:body].nil? && !response[:body].is_a?(String)
          if response[:body].key?(:session)
            define_session_id(response[:body][:session][:id])
          end
        end
      end

      def parse_response(response)
        response_code = response.code
        response_msg = response.msg

        response_body = response.read_body
        response_body = nil if [STATUS_CODE.not_found].include?(response_code)          
        response_body = parse_xml_to_hash(response.read_body) if ![STATUS_CODE.unauthorized, STATUS_CODE.not_found].include?(response_code)

        {
          code: response_code,
          message: response_msg,
          body: response_body
        }
      end
    end
  end
end
