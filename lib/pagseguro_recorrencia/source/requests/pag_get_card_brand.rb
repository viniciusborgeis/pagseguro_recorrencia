require 'uri'
require 'net/http'
require 'pagseguro_recorrencia/source/requests/request_application'
require 'pagseguro_recorrencia/source/builds/build_url_param'

module PagseguroRecorrencia
  module PagRequests
    class GetCardBrand < RequestApplication
      def receive(card_bin)
        params = {
          session_id: PagseguroRecorrencia::PagCore.configuration.session_id,
          card_bin: card_bin
        }
        url = url_credit_card(params, :get_card_brand)

        https, request = request_https(url, :get).values_at(:https, :request)

        response = request_safe(https, request)
        parsed_response = parse_response(response)

        return receive(card_bin) if check_session_id(parsed_response)

        parsed_response
      end

      private

      def check_session_id(response)
        recall = false
        if !response[:body].nil? && response[:body].key?(:safe_checkout_response)
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
          response_body = parse_json_to_hash(response.read_body) 
          if response_body.key?(:bin) && response_body[:bin][:status_message] == 'Error'
            hash = Hash.new
            hash[:status_message] = response_body[:bin][:status_message]
            hash[:reason_message] = response_body[:bin][:reason_message]
            response_body = hash
          end
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
