require 'uri'
require 'net/http'
require 'pagseguro_recorrencia/source/core/pag_core'
require 'pagseguro_recorrencia/source/requests/bodies/body_new_card_token'

module PagseguroRecorrencia
  module PagRequests
    class GetCardBrand < RequestApplication
      def receive(card_bin)
        url = "https://df.uol.com.br/df-fe/mvc/creditcard/v1/getBin?tk=#{PagseguroRecorrencia::PagCore.configuration.session_id}&creditCard=#{card_bin}"

        https, request = build_https_request(url, :get).values_at(:https, :request)
        response = request_safe(https, request)
        return receive(card_bin) if check_session_id(response)

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
        if response[:body].key?(:safeCheckoutResponse)
          PagseguroRecorrencia.new_session
          recall = true
        end
        recall
      end

      def parse_response(response)
        response_code = response.code
        response_msg = response.msg
        response_body = parse_json_to_hash(response.read_body)

        {
          code: response_code,
          message: response_msg,
          body: response_body
        }
      end
    end
  end
end
