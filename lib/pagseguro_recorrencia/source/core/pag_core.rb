require 'active_support/core_ext/hash'
require 'json'
require 'pagseguro_recorrencia/configuration'

module PagseguroRecorrencia
  class PagCore
    attr_accessor :configuration

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
end
