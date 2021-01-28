#################################################################
#   ================= Entendendo os Campos =================    #
#   method: POST                                                #
#                                                               #
#                                                               #
#   |--> Nome do Plano                                          #
#                                                               #
#   - :charge_type [<charge>]                                   #
#   |--> Tipo de Cobrança ( AUTO || MANUAL )                    #
#                                                               #
#   - :period <period>                                          #
#   |--> Periodicidade do plano                                 #
#   |--> ( WEEKLY, MONTHLY, BIMONTHLY, TRIMONTHLY,              #
#         SEMIANNUALLY, YEARLY )                                #
#                                                               #
#   - :cancel_url [<cancelURL>]                                 #
#   |--> URL de cancelamento ( https://... )                    #
#                                                               #
#   - :amount_per_payment [<amountPerPayment>]                  #
#   |--> Valor máximo cobrado por período ( 999.99 )            #
#                                                               #
#   - :membership_fee [<membershipFee>]                         #
#   |--> Taxa de adesão/matricula ( 999.99 )                    #
#                                                               #
#   - :trial_period_duration [<trialPeriodDuration>]            #
#   |--> Tempo de teste ( 99 )                                  #
#                                                               #
#   - :expiration_value [<expiration> -> <value>]               #
#   |--> Número de cobranças que serão realizadas ( 99 )        #
#                                                               #
#   - :expiration_unit [<expiration> -> <unit>]                 #
#   |--> Período em que as cobranças serão realizadas           #
#   |--> ( DAYS, MONTHS, YEARS )                                #
#                                                               #
#   - :max_uses [<maxUses>]                                     #
#   |--> Quantidade máxima de uso do plano ( 999 )              #
#                                                               #
#   ~~~~~~~~~~~~~~~~~~~~~~~ ATENÇÃO! ~~~~~~~~~~~~~~~~~~~~~~~    #
#           Para criar planos sem data de expiração,            #
#               basta não informar os parâmetros                #
#           ':expiration_unit' e ':expiration_value'            #
#   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    #
#################################################################

#################################################################
#      ================= Exemplo Payload =================      #
#           payload = {                                         #
#               :plan_name => 'TEST - 1',                       #
#               :charge_type => :manual,                        #
#               :period => :monthly,                            #
#               :cancel_url => '',                              #
#               :amount_per_payment => '200.00',                #
#               :membership_fee => '150.00',                    #
#               :trial_period_duration => '28',                 #
#               :expiration_value => '10',                      #
#               :expiration_unit => :months,                    #
#               :max_uses => '500',                             #
#               :plan_identifier => 'TEST123',                  #
#           }                                                   #
#################################################################

#################################################################
#     ============= Exemplo Response Success =============      #
#        {                                                      #
#            :code => "200",                                    #
#            :message => "OK",                                  #
#            :body => {                                         #
#                :code => "F10D4293FCFC3F7554C9CFB42BF62DC9"    #
#                :date => "2021-01-25T15:37:15-03:00"           #
#            }                                                  #
#        }                                                      #
#################################################################

#################################################################
#     ============== Exemplo Response Error ==============      #
#        {                                                      #
#            :code => "400",                                    #
#            :message => "Bad Request",                         #
#            :body => {                                         #
#                :error => {                                    #
#                    :code => "11087",                          #
#                    :message => "cancelURL invalid pattern:..."#
#                }                                              #
#            }                                                  #
#        }                                                      #
#################################################################

require 'uri'
require 'net/http'
require 'pagseguro_recorrencia/source/core/pag_core'
require 'pagseguro_recorrencia/source/requests/bodies/body_new_plan'
require 'pagseguro_recorrencia/source/helpers/pag_helpers'

module PagseguroRecorrencia
  module PagRequests
    class NewPlan < PagCore
      
      def create(payload)
        PagseguroRecorrencia::Helpers.check_required_payload_presencies(payload, required_params)
        replaced_payload = replace_sensitive_field_with_present(payload)
        body = build_body_xml(replaced_payload)
        do_request(body)
      end

      private

      def do_request(body)
        url = URI(PagseguroRecorrencia::Helpers.build_environment_url(PagseguroRecorrencia::PagCore.configuration, :new_plan))

        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true

        request = Net::HTTP::Post.new(url)
        request['Accept'] = 'application/vnd.pagseguro.com.br.v3+xml;charset=ISO-8859-1'
        request['Content-Type'] = 'application/xml;charset=ISO-8859-1'
        request.body = body

        response = https.request(request)

        3.times do |_i|
          response = https.request(request)
          break if response.code != '404'
        end

        parse_response(response)
      end

      def parse_response(response)
        response_code = response.code
        response_msg = response.msg
        if response_code == '200'
          response_body = PagseguroRecorrencia::Helpers.parse_xml_to_hash(response.read_body)[:preApprovalRequest]
        end
        if response_code == '400'
          response_body = PagseguroRecorrencia::Helpers.parse_xml_to_hash(response.read_body)[:errors]
        end
        response_body = PagseguroRecorrencia::Helpers.parse_xml_to_hash(response.read_body) unless %w[200 400]

        {
          code: response_code,
          message: response_msg,
          body: response_body
        }
      end

      def replace_sensitive_field_with_present(payload)
        replaced_payload = check_sensitive_value(payload, :charge_type, charge_type_values)
        replaced_payload = check_sensitive_value(replaced_payload, :period, period_values)
        check_sensitive_value(replaced_payload, :expiration_unit, expiration_unit_values)
      end

      def check_sensitive_value(payload, key, params)
        return unless payload.key?(key)

        tmp_payload = payload.dup

        params.map { |value| tmp_payload[key] = value.to_s.upcase if payload[key].to_sym == value }
        if tmp_payload[key] == payload[key]
          raise "[VALUE_ERROR] :#{key} can only receive these values (#{params.map do |v|
                                                                          ':' + v.to_s
                                                                        end.join(', ')})"
        end

        tmp_payload
      end

      def required_params
        %i[
          plan_name
          charge_type
          amount_per_payment
        ]
      end

      def charge_type_values
        %i[manual auto]
      end

      def period_values
        %i[weekly monthly bimonthly trimonthly semiannually yearly]
      end

      def expiration_unit_values
        %i[days months years]
      end
    end
  end
end
