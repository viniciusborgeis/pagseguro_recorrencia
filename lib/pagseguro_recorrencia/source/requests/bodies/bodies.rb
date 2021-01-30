require_relative 'xml_bodies/xml_body_new_plan'

module PagseguroRecorrencia
  module PagRequests
    module Bodies
      extend self

      def build_get_card_brand(payload)
        url = 'https://df.uol.com.br/df-fe/mvc/creditcard/v1/getBin?'
        session_id = "tk=#{payload[:session_id]}"
        card_bin = "creditCard=#{payload[:card_bin]}"

        data_info = [session_id, card_bin].join('&')
        url.concat(data_info)
      end

      def build_new_card_token(payload)
        session_id = "sessionId=#{payload[:session_id]}"
        amount = "amount=#{payload[:amount]}"
        card_number = "cardNumber=#{payload[:card_number].delete(' ')}"
        card_brand = "amoucardBrandnt=#{payload[:card_brand]}"
        card_cvv = "cardCvv=#{payload[:card_cvv]}"
        card_expiration_month = "cardCvv=#{payload[:card_expiration_month]}"
        card_expiration_year = "cardExpirationYear=#{payload[:card_expiration_year]}"

        data_info = [session_id, amount, card_number, card_brand, card_cvv, card_expiration_month,
                     card_expiration_year]

        data_info.join('&')
      end
    end
  end
end
