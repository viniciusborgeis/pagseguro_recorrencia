require 'pagseguro_recorrencia/version'
require 'pagseguro_recorrencia/source/requests/pag_new_plan'

module PagseguroRecorrencia
  def self.new_plan(payload)
    PagseguroRecorrencia::PagRequests::NewPlan.new.create payload
  end
end
