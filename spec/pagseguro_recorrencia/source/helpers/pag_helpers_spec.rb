require 'spec_helper'
require 'support/helpers/helper'

RSpec.describe PagseguroRecorrencia::Helpers do

  context 'when call build_environment_url() method' do
    it 'passing sandbox configuration(:sandbox) and return sandbox URL' do
      PagseguroRecorrencia::PagCore.reset
      PagseguroRecorrencia::PagCore.configure do |config|
        config.credential_email = 'test@test.com'
        config.credential_token = '5A9045945CD85239E8F8BDF34532DBA460'
        config.environment = :sandbox
        config.cancel_url = nil
      end
  
  
      builded_url = PagseguroRecorrencia::Helpers.build_environment_url(PagseguroRecorrencia::PagCore.configuration)
      environment_string = builded_url.content_around('ws', 'pagseguro')
      expect(builded_url.class).to eq(String)
      expect(builded_url).to eq('https://ws.sandbox.pagseguro.uol.com.br/pre-approvals/request?email=test@test.com&token=5A9045945CD85239E8F8BDF34532DBA460')
      expect(environment_string).to eq('.sandbox.')
    end
  
    it 'passing production(:sandbox) configuration and return production URL' do
      PagseguroRecorrencia::PagCore.reset
      PagseguroRecorrencia::PagCore.configure do |config|
        config.credential_email = 'test@test.com'
        config.credential_token = '5A9045945CD85239E8F8BDF34532DBA460'
        config.environment = :production
        config.cancel_url = nil
      end
  
      builded_url = PagseguroRecorrencia::Helpers.build_environment_url(PagseguroRecorrencia::PagCore.configuration)
      environment_string = builded_url.content_around('ws', 'pagseguro')
      expect(builded_url.class).to eq(String)
      expect(builded_url).to eq('https://ws.pagseguro.uol.com.br/pre-approvals/request?email=test@test.com&token=5A9045945CD85239E8F8BDF34532DBA460')
      expect(environment_string).to eq('.') # ws.pagseguro character '.' around this string
    end
  
    it 'passing wrong environment configuration return raise' do
      PagseguroRecorrencia::PagCore.reset
      PagseguroRecorrencia::PagCore.configure do |config|
        config.credential_email = 'test@test.com'
        config.credential_token = '5A9045945CD85239E8F8BDF34532DBA460'
        config.environment = :wrog_environment
        config.cancel_url = nil
      end
  
      expect { PagseguroRecorrencia::Helpers.build_environment_url(PagseguroRecorrencia::PagCore.configuration) }
        .to raise_error(StandardError, '[WRONG_ENVIRONMENT] environment: receive only (:sandbox :production), you pass :wrog_environment')     
    end
  end

  context 'when call parse_xml_to_hash() method' do
    it 'pass correct XML data and return Hash' do
      xml = '<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?><preApprovalRequest><preApproval><name>TEST - 1</name></preApproval></preApprovalRequest>'
      xml_parsed = PagseguroRecorrencia::Helpers.parse_xml_to_hash(xml)
      
      expect(xml_parsed.class).to eq(Hash)
      expect(xml_parsed.key?(:preApprovalRequest)).to be_truthy
      expect(xml_parsed[:preApprovalRequest].key?(:preApproval)).to be_truthy
      expect(xml_parsed[:preApprovalRequest][:preApproval].key?(:name)).to be_truthy

      expect(xml_parsed[:preApprovalRequest].class).to eq(Hash)
      expect(xml_parsed[:preApprovalRequest][:preApproval].class).to eq(Hash)
      expect(xml_parsed[:preApprovalRequest][:preApproval][:name].class).to eq(String)
      expect(xml_parsed[:preApprovalRequest][:preApproval][:name]).to eq('TEST - 1')
    end

    it 'pass wrong XML data missing close tag </name> and return raise' do
      xml = '<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?><preApprovalRequest><preApproval><name>TEST - 1</preApproval></preApprovalRequest>'
      expect { PagseguroRecorrencia::Helpers.parse_xml_to_hash(xml) }.to raise_error(StandardError)
    end
  end

  context 'when call check_required_payload_presencies() method' do
    it 'pass correct payload data' do
      payload = {
        plan_name: 'TEST - 1',
        charge_type: :manual,
        period: :monthly,
        cancel_url: '',
        amount_per_payment: '200.00',
        membership_fee: '150.00',
        trial_period_duration: '28',
        expiration_value: '10',
        expiration_unit: :months,
        max_uses: '500',
        plan_identifier: 'TEST123'
      }

      required_params = %i[ plan_name charge_type amount_per_payment ]
      expect( PagseguroRecorrencia::Helpers.check_required_payload_presencies(payload, required_params) ).to be_truthy
    end

    it 'pass incorrect payload data, missing :plan_name' do
      payload = {
        charge_type: :manual,
        period: :monthly,
        cancel_url: '',
        amount_per_payment: '200.00',
        membership_fee: '150.00',
        trial_period_duration: '28',
        expiration_value: '10',
        expiration_unit: :months,
        max_uses: '500',
        plan_identifier: 'TEST123'
      }

      required_params = %i[ plan_name charge_type amount_per_payment ]
      expect { PagseguroRecorrencia::Helpers.check_required_payload_presencies(payload, required_params) }.to raise_error(StandardError, '[MISSING_PAYLOAD_FIELD] :plan_name')
    end

    it 'pass incorrect payload data, missing :plan_name' do
      payload = {
        plan_name: 'TEST - 1',
        period: :monthly,
        cancel_url: '',
        amount_per_payment: '200.00',
        membership_fee: '150.00',
        trial_period_duration: '28',
        expiration_value: '10',
        expiration_unit: :months,
        max_uses: '500',
        plan_identifier: 'TEST123'
      }

      required_params = %i[ plan_name charge_type amount_per_payment ]
      expect { PagseguroRecorrencia::Helpers.check_required_payload_presencies(payload, required_params) }.to raise_error(StandardError, '[MISSING_PAYLOAD_FIELD] :charge_type')
    end

    it 'pass incorrect payload data, missing :amount_per_payment' do
      payload = {
        plan_name: 'TEST - 1',
        charge_type: :manual,
        period: :monthly,
        cancel_url: '',
        membership_fee: '150.00',
        trial_period_duration: '28',
        expiration_value: '10',
        expiration_unit: :months,
        max_uses: '500',
        plan_identifier: 'TEST123'
      }

      required_params = %i[ plan_name charge_type amount_per_payment ]
      expect { PagseguroRecorrencia::Helpers.check_required_payload_presencies(payload, required_params) }.to raise_error(StandardError, '[MISSING_PAYLOAD_FIELD] :amount_per_payment')
    end

    it 'pass incorrect payload data' do
      payload = [ "asd", 123]

      required_params = %i[ plan_name charge_type amount_per_payment ]
      expect { PagseguroRecorrencia::Helpers.check_required_payload_presencies(payload, required_params) }.to raise_error(RuntimeError)
    end
  end

  
end
