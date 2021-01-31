require 'uri'
require 'net/http'
require 'pagseguro_recorrencia/source/core/pag_core'
require 'pagseguro_recorrencia/source/core/raises'
require 'pagseguro_recorrencia/source/core/constants'
require 'pagseguro_recorrencia/source/builds/build_url'
require 'pagseguro_recorrencia/source/builds/build_url_param'
require 'pagseguro_recorrencia/source/builds/build_header'
require 'pagseguro_recorrencia/source/builds/build_requests'

module PagseguroRecorrencia
  module PagRequests
    class RequestApplication < PagCore
      include PagseguroRecorrencia::Constants
      include PagseguroRecorrencia::Raises
      include PagseguroRecorrencia::Builds::URL
      include PagseguroRecorrencia::Builds::UrlParam
      include PagseguroRecorrencia::Builds::Header
      include PagseguroRecorrencia::Builds::Requests
      STATUS_CODE = StatusCode      

      def request_safe(https, request)
        response = https.request(request)

        3.times do |_i|
          break if ![STATUS_CODE.not_found].include?(response.code) 

          response = https.request(request)
        end

        response
      end

      def check_required_payload_presencies(payload, params)
        params.map { |key, _value| payload.fetch(key.to_sym) }
      rescue KeyError => e
        raise_missing_payload_field(e)
      rescue StandardError => e
        raise_explicit(e)
      end

      def define_session_id(session_id)
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
