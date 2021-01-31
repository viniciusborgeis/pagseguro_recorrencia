require 'nokogiri'

module PagseguroRecorrencia
  module Builds
    module XML
      extend self

      def new_plan(payload)
        xml_config = Nokogiri::XML("<?xml version='1.0' encoding='ISO-8859-1' standalone='yes'?>")

        Nokogiri::XML::Builder.with(xml_config) do |xml|
          xml.preApprovalRequest do
            xml.preApproval do
              build_field(xml, 'name', payload, :plan_name)
              build_field(xml, 'charge', payload, :charge_type)
              build_field(xml, 'period', payload, :period)
              build_field(xml, 'cancelURL', payload, :cancel_url)
              build_field(xml, 'amountPerPayment', payload, :amount_per_payment)
              build_field(xml, 'membershipFee', payload, :membership_fee)
              build_field(xml, 'trialPeriodDuration', payload, :trial_period_duration)
              if payload.key?(:expiration_value) || payload.key?(:expiration_unit)
                xml.expiration do
                  build_field(xml, 'value', payload, :expiration_value)
                  build_field(xml, 'unit', payload, :expiration_unit)
                end
              end
            end
            build_field(xml, 'maxUses', payload, :max_uses)
            build_field(xml, 'reference', payload, :plan_identifier)
          end
        end.to_xml.delete!("\n")
      end

      private

      def build_field(xml, field_name, payload, key)
        return unless payload.key?(key)
        return if payload[key].empty?

        xml.send(field_name, payload[key])
      end
    end
  end
end
