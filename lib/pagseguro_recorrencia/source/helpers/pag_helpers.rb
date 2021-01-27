require 'pagseguro_recorrencia/source/helpers/pag_load_file'
module Helpers
  def build_environment_url(configuration)
    request_url_environment = 'https://ws.sandbox.pagseguro.uol.com.br' if configuration.environment == :sandbox
    request_url_environment = 'https://ws.pagseguro.uol.com.br' if configuration.environment == :production
    request_url_email = "email=#{configuration.credential_email}"
    request_url_token = "token=#{configuration.credential_token}"
    "#{request_url_environment}/pre-approvals/request?#{request_url_email}&#{request_url_token}"
  end

  def parse_xml_to_hash(xml)
    new_hash = Hash.from_xml(xml).to_json
    JSON.parse(new_hash, { symbolize_names: true })
  end

  def print_exception_missing_key(exception)
    puts "[MISSING_PAYLOAD_FIELD] :#{exception.key}"
    puts exception.backtrace.join("\n")
  end

  def print_exception(exception, explicit)
    puts "[#{explicit ? 'EXPLICIT' : 'INEXPLICIT'}] #{exception.class}: #{exception.message}"
    puts exception.backtrace.join("\n")
  end

  def check_required_payload_presencies(payload, params)
    params.map { |key, _value| payload.fetch(key.to_sym) }
  rescue KeyError => e
    print_exception_missing_key(e)
  rescue StandardError => e
    print_exception(e, false)
  end
end
