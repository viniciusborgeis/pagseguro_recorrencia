module PagseguroRecorrencia
  class Configuration
    attr_accessor :credential_email, :credential_token, :environment, :cancel_url

    def initialize
      @credential_email = nil
      @credential_token = nil
      @environment = nil
      @cancel_url = nil
    end
  end
end
