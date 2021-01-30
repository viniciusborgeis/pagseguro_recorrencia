class String
  def present?
    !strip.empty?
  end
end

module PagseguroRecorrencia
  module PagRequests
    module XmlBodies
      extend self

      def build_new_plan_xml(payload)
        %(
          <?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>
          <preApprovalRequest>
            <preApproval>
              #{build_new_plan_pre_approval_content_xml(payload)}
            </preApproval>
            #{build_new_plan_field_xml('maxUses', payload, :max_uses)}
          </preApprovalRequest>
        ).gsub(/\s+/, ' ').strip
      end

      def build_new_plan_pre_approval_content_xml(payload)
        %(
          #{build_new_plan_field_xml('name', payload, :plan_name)}
          #{build_new_plan_field_xml('charge', payload, :charge_type)}
          #{build_new_plan_field_xml('period', payload, :period)}
          #{build_new_plan_field_xml('cancelURL', payload, :cancel_url)}
          #{build_new_plan_field_xml('amountPerPayment', payload, :amount_per_payment)}
          #{build_new_plan_field_xml('membershipFee', payload, :membership_fee)}
          #{build_new_plan_field_xml('trialPeriodDuration', payload, :trial_period_duration)}
          #{build_new_plan_field_xml('reference', payload, :plan_identifier)}
          #{build_new_plan_expiration_field_xml(payload)}
        ).gsub(/\s+/, ' ').strip
      end

      def build_new_plan_field_xml(tag_name, payload, key)
        payload.key?(key) ? "<#{tag_name}>#{payload[key]}</#{tag_name}>" : ''
      end

      def build_new_plan_expiration_field_xml(payload)
        expiration_value = build_new_plan_field_xml('value', payload, :expiration_value)
        expiration_unit = build_new_plan_field_xml('unit', payload, :expiration_unit)
        expiration = ''

        if expiration_value.present? || expiration_unit.present?
          expiration = "<expiration>#{expiration_value}#{expiration_unit}</expiration>".gsub(/\s+/, ' ').strip
        end

        expiration
      end
    end
  end
end
