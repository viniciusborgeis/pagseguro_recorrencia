require 'pagseguro_recorrencia/version'
require 'pagseguro_recorrencia/source/requests/pag_new_plan'
require 'pagseguro_recorrencia/source/requests/pag_new_session'

module PagseguroRecorrencia
  def self.new_plan(payload)
    PagseguroRecorrencia::PagRequests::NewPlan.new.create payload
  end

  def self.new_session
    PagseguroRecorrencia::PagRequests::NewSession.new.create
  end
end
