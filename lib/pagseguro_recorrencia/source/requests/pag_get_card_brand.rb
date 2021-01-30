require 'uri'
require 'net/http'
require 'pagseguro_recorrencia/source/requests/request_application'
require 'pagseguro_recorrencia/source/requests/bodies/bodies'

module PagseguroRecorrencia
  module PagRequests
    class GetCardBrand < RequestApplication
      def receive(card_bin)
        payload = Hash.new
        payload[:session_id] = PagseguroRecorrencia::PagCore.configuration.session_id
        payload[:card_bin] = card_bin
        url =  PagseguroRecorrencia::PagRequests::Bodies.build_get_card_brand(payload)

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
        if response[:body].key?(:safe_checkout_response)
          PagseguroRecorrencia.new_session
          recall = true
        end
        recall
      end

      def parse_response(response)
        response_code = response.code
        response_msg = response.msg
        response_body = parse_json_to_hash(response.read_body)
        if response_body.key?(:bin) && response_body[:bin][:status_message] == 'Error'
          hash = Hash.new
          hash[:status_message] = response_body[:bin][:status_message]
          hash[:reason_message] = response_body[:bin][:reason_message]
          response_body = hash
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
