require 'uri'
require 'net/http'
require 'pagseguro_recorrencia/source/requests/request_application'


module PagseguroRecorrencia
  module PagRequests
    class NewCardToken < RequestApplication
      def create(payload)
        header = { content_type: header_content_type(:form) }
        payload[:session_id] = PagseguroRecorrencia::PagCore.configuration.session_id
        url = url_credit_card(payload, :new_card_token)

        https, request = request_https(url, :post, header).values_at(:https, :request)
        request.body = url_param_new_card_token(payload)

        response = request_safe(https, request)
        parsed_response = parse_response(response)

        return create(payload) if check_session_id(parsed_response)

        parsed_response
      end

      private

      def check_session_id(response)
        recall = false
        if !response[:body].nil? && response[:body].key?(:card) && response[:body][:card].nil?
          PagseguroRecorrencia.new_session
          recall = true
        end
        recall
      end

      def parse_response(response)
        response_code = response.code
        response_msg = response.msg
        response_body = nil

        if response_code != STATUS_CODE.not_found
          response_body = parse_xml_to_hash(response.read_body)
          response_body = response_body[:errors] if response_body.key?(:errors)
        end

        {
          code: response_code,
          message: response_msg,
          body: response_body
        }
      end
    end
  end
end
