require 'uri'
require 'net/http'
require 'ruby-enum'
require 'pagseguro_recorrencia/source/core/pag_core'

module PagseguroRecorrencia
  module PagRequests
    class StatusCode
      include Ruby::Enum

      define :ok, '200'
      define :bad_request, '400'
      define :unauthorized, '401'
      define :not_found, '404'
    end

    class RequestApplication < PagCore
      def status_code
        StatusCode
      end

      def build_environment_url(configuration, request_type)
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

      def request_types(request_type)
        return '/pre-approvals/request?' if request_type == :new_plan
        return '/v2/sessions?' if request_type == :new_session
      end

      def build_https_request(url_request, request_type, content_type = nil, accept = nil)
        url = URI(url_request)

        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true

        request = Net::HTTP::Post.new(url) if request_type == :post
        request = Net::HTTP::Get.new(url) if request_type == :get
        request['Content-Type'] = content_type unless content_type.nil?
        request['Accept'] = accept unless accept.nil?

        {
          https: https,
          request: request
        }
      end

      def check_required_payload_presencies(payload, params)
        params.map { |key, _value| payload.fetch(key.to_sym) }
      rescue KeyError => e
        error = "[MISSING_PAYLOAD_FIELD] :#{e.key}"
        raise error
      rescue StandardError => e
        error = "[EXPLICIT] #{e.class}: #{e.message}"
        raise error
      end

      def define_session_id session_id
        PagseguroRecorrencia::PagCore.configure do |config|
          config.session_id = session_id
        end
      end

      def parse_xml_to_hash(xml)
        new_json = Hash.from_xml(xml).to_json
        parse_json_to_hash(new_json)
      end

      def parse_json_to_hash(json)
        hash = JSON.parse(json, { symbolize_names: true })
        hash.deep_transform_keys { |key| key.to_s.underscore.to_sym }
      end
    end
  end
end
