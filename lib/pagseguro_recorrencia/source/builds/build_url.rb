require 'pagseguro_recorrencia/source/core/constants'

module PagseguroRecorrencia
  module Builds
    module URL
      extend self
      include PagseguroRecorrencia::Constants

      def url_ws_pagseguro(configuration)
        environment_config = configuration.environment
        return Url.ws_pagseguro_prod if %i[production].include?(environment_config)
        return Url.ws_pagseguro_sand if %i[sandbox].include?(environment_config)
      end

      def url_environment(configuration, route)
        raise_wrong_environment unless %i[sandbox production].include?(configuration.environment)

        request_url_environment = url_ws_pagseguro(configuration)
        request_url_param = url_param_new_plan(configuration)
        request_url_route = request_route(route)
        "#{request_url_environment}#{request_url_route}#{request_url_param}"
      end

      def url_credit_card(payload, route)
        request_url = Url.df_uol
        request_url_route = request_route(route)
        request_url_param = url_get_card_brand(payload) if %i[get_card_brand].include?(route)

        "#{request_url}#{request_url_route}#{request_url_param}"
      end

      def request_route(route)
        return Routes.ws_pagseguro_new_plan if %i[new_plan].include?(route)
        return Routes.ws_pagseguro_new_session if %i[new_session].include?(route)
        return Routes.df_uol_card_token if %i[new_card_token].include?(route)
        return Routes.df_uol_card_brand if %i[get_card_brand].include?(route)
      end
      
    end
  end
end
