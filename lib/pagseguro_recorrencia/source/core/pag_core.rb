require 'active_support/core_ext/hash'
require 'json'
require 'pagseguro_recorrencia/configuration'
require 'pagseguro_recorrencia/source/helpers/pag_helpers'

module PagseguroRecorrencia
  include Helpers
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= PagseguroRecorrencia::Configuration.new
  end

  def self.reset
    @configuration = PagseguroRecorrencia::Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
