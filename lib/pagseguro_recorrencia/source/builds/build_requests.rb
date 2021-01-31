module PagseguroRecorrencia
  module Builds
    module Requests
      extend self

      def request_https(url_request, request_type, header = nil)
        url = URI(url_request)

        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true

        request = Net::HTTP::Post.new(url) if %i[post].include?(request_type)
        request = Net::HTTP::Get.new(url) if %i[get].include?(request_type)
        request['Content-Type'] = header[:content_type] if !header.nil? && header.key?(:content_type)
        request['Accept'] = header[:accept] if !header.nil? && header.key?(:accept)

        {
          https: https,
          request: request
        }
      end
    end
  end
end
