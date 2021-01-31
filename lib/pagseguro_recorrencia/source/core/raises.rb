module PagseguroRecorrencia
  module Raises
    extend self

    def raise_wrong_environment
      config_environment = PagseguroRecorrencia::PagCore.configuration.environment
      raise_message = "[WRONG_ENVIRONMENT] environment: receive only (:sandbox :production), you pass :#{config_environment}"
      raise raise_message
    end

    def raise_missing_payload_field(error)
      error_msg = "[MISSING_PAYLOAD_FIELD] :#{error.key}"
      raise error_msg
    end

    def raise_explicit(error)
      error_msg = "[EXPLICIT] #{error.class}: #{error.message}"
      raise error_msg
    end

    def raise_value_error(key, received_params)
      raise_message = "[VALUE_ERROR] :#{key} can only receive these values (#{received_params})"
      raise raise_message
    end
  end
end
