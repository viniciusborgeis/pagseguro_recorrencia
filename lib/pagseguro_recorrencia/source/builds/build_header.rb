module PagseguroRecorrencia
  module Builds
    module Header
      extend self

      def header_content_type(params = nil)
        doc_format = 'xml'
        charset = 'ISO-8859-1'

        unless params.nil?
          doc_format = params[:format] if params.is_a?(Hash) && params.key?(:format)
          charset =  params[:charset] if params.is_a?(Hash) && params.key?(:format)
          return 'application/x-www-form-urlencoded' if [:form].include?(params)
        end

        "application/#{doc_format};charset=#{charset}"
      end

      def header_accept(params = nil)
        doc_format = 'xml'
        charset = 'ISO-8859-1'

        unless params.nil?
          doc_format = params[:format] if params.is_a?(Hash) && params.key?(:format)
          charset =  params[:charset] if params.is_a?(Hash) && params.key?(:format)
        end

        "application/vnd.pagseguro.com.br.v3+#{doc_format};charset=#{charset}"
      end
    end
  end
end
