
require 'uri'
require 'net/http'
require 'pagseguro_recorrencia/source/core/pag_core'
require 'pagseguro_recorrencia/source/helpers/pag_helpers'

module PagseguroRecorrencia
  module PagRequests
    class NewSession < PagCore

      def create
        url = URI(PagseguroRecorrencia::Helpers.build_environment_url(PagseguroRecorrencia::PagCore.configuration, :new_session))

        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true

        request = Net::HTTP::Post.new(url)
        request["Content-Type"] = "application/x-www-form-urlencoded"

        response = https.request(request)

        3.times do |_i|
          response = https.request(request)
          break if response.code != '404'
        end

        parse_response(response)
      end

      private

      def parse_response(response)
        response_code = response.code
        response_msg = response.msg
        if response_code == '200'
          response_body = PagseguroRecorrencia::Helpers.parse_xml_to_hash(response.read_body)
        end
        if response_code == '401'
          response_body = response.read_body
        end
        response_body = PagseguroRecorrencia::Helpers.parse_xml_to_hash(response.read_body) unless %w[200 400]

        {
          code: response_code,
          message: response_msg,
          body: response_body
        }
      end
      
    end
  end
end
