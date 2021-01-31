require 'pagseguro_recorrencia/source/core/constants'

module PagseguroRecorrencia
  module Builds
    module UrlParam
      extend self
      include PagseguroRecorrencia::Constants

      def url_param_new_plan(params)
        data_info = [
          "email=#{params.credential_email}",
          "token=#{params.credential_token}"  
        ].join('&')
      end

      def url_get_card_brand(params)
        data_info = [
          "tk=#{params[:session_id]}",
          "creditCard=#{params[:card_bin]}"
        ].join('&')
      end

      def url_param_new_card_token(params)
        data_info = [
          "sessionId=#{params[:session_id]}",
          "amount=#{params[:amount]}",
          "cardNumber=#{params[:card_number].delete(' ')}",
          "amoucardBrandnt=#{params[:card_brand]}",
          "cardCvv=#{params[:card_cvv]}",
          "cardCvv=#{params[:card_expiration_month]}",
          "cardExpirationYear=#{params[:card_expiration_year]}"
        ].join('&')
      end
      
    end
  end
end
