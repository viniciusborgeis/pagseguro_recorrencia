module PagseguroRecorrencia
  class Configuration
    attr_accessor :credential_email, :credential_token, :environment, :cancel_url, :session_id

    def initialize
      @credential_email = nil
      @credential_token = nil
      @environment = nil
      @cancel_url = nil
      @session_id = nil
    end
  end
end
