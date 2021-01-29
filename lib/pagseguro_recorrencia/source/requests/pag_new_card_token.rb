require 'uri'
require 'net/http'
require 'pagseguro_recorrencia/source/core/pag_core'
require 'pagseguro_recorrencia/source/requests/bodies/body_new_card_token'
require 'pagseguro_recorrencia/source/requests/request_application'

module PagseguroRecorrencia
  module PagRequests
    class NewCardToken < RequestApplication
      def create(payload)
        url = 'https://df.uol.com.br/v2/cards'
        content_type = 'application/x-www-form-urlencoded'
        payload[:session_id] = PagseguroRecorrencia::PagCore.configuration.session_id

        https, request = build_https_request(url, :post, content_type).values_at(:https, :request)
        request.body = build_body(payload)
        response = request_safe(https, request)
        return create(payload) if check_session_id(response)

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

      def check_session_id(response)
        recall = false
        if response[:body].key?(:card) && response[:body][:card].nil?
          PagseguroRecorrencia.new_session
          recall = true
        end
        recall
      end

      def parse_response(response)
        response_code = response.code
        response_msg = response.msg
        response_body = parse_xml_to_hash(response.read_body)
        response_body = response_body[:errors] if response_body.key?(:errors)

        {
          code: response_code,
          message: response_msg,
          body: response_body
        }
      end
    end
  end
end
