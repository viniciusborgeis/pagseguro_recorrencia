require 'pagseguro_recorrencia/version'
require 'pagseguro_recorrencia/source/requests/pag_new_plan'
require 'pagseguro_recorrencia/source/requests/pag_new_session'
require 'pagseguro_recorrencia/source/requests/pag_new_card_token'
require 'pagseguro_recorrencia/source/requests/pag_get_card_brand'

module PagseguroRecorrencia
  extend self

  def new_plan(payload)
    PagseguroRecorrencia::PagRequests::NewPlan.new.create payload
  end

  def new_session
    PagseguroRecorrencia::PagRequests::NewSession.new.create
  end

  def new_card_token payload
    PagseguroRecorrencia::PagRequests::NewCardToken.new.create payload
  end

  def get_card_brand bin
    PagseguroRecorrencia::PagRequests::GetCardBrand.new.receive bin
  end
end
