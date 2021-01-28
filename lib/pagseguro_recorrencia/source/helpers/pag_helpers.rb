module PagseguroRecorrencia
  class Helpers
    def self.build_environment_url(configuration, request_type)
      if configuration.environment != :sandbox && configuration.environment != :production
        raise_message = "[WRONG_ENVIRONMENT] environment: receive only (:sandbox :production), you pass :#{configuration.environment}"
        raise raise_message
      end

      request_url_environment = 'https://ws.sandbox.pagseguro.uol.com.br' if configuration.environment == :sandbox
      request_url_environment = 'https://ws.pagseguro.uol.com.br' if configuration.environment == :production
      request_url_email = "email=#{configuration.credential_email}"
      request_url_token = "token=#{configuration.credential_token}"
      "#{request_url_environment}#{request_types(request_type)}#{request_url_email}&#{request_url_token}"
    end

    def self.request_types(request_type)
      return '/pre-approvals/request?' if request_type == :new_plan
      return '/v2/sessions?' if request_type == :new_session
    end

    def self.parse_xml_to_hash(xml)
      new_hash = Hash.from_xml(xml).to_json
      JSON.parse(new_hash, { symbolize_names: true })
    end

    def self.check_required_payload_presencies(payload, params)
      params.map { |key, _value| payload.fetch(key.to_sym) }
    rescue KeyError => e
      error = "[MISSING_PAYLOAD_FIELD] :#{e.key}"
      raise error
    rescue StandardError => e
      error = "[EXPLICIT] #{e.class}: #{e.message}"
      raise error
    end
  end
end
