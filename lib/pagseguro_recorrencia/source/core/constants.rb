require 'ruby-enum'

module PagseguroRecorrencia
  module Constants

    class StatusCode
      include Ruby::Enum

      define :ok, '200'
      define :bad_request, '400'
      define :unauthorized, '401'
      define :not_found, '404'
    end

    class Url
      include Ruby::Enum

      define :ws_pagseguro_prod, 'https://ws.pagseguro.uol.com.br'
      define :ws_pagseguro_sand, 'https://ws.sandbox.pagseguro.uol.com.br'
      define :df_uol, 'https://df.uol.com.br'
    end

    class Routes
      include Ruby::Enum

      define :ws_pagseguro_new_plan, '/pre-approvals/request?'
      define :ws_pagseguro_new_session, '/v2/sessions?'
      define :df_uol_card_token, '/v2/cards'
      define :df_uol_card_brand, '/df-fe/mvc/creditcard/v1/getBin?'
    end

  end
end
