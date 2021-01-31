require 'spec_helper'
require 'support/helpers/helper'

RSpec.describe PagseguroRecorrencia::PagRequests::RequestApplication do

  context 'when call url_environment() method' do
    it 'passing sandbox configuration(:sandbox) and return sandbox URL' do
      PagseguroRecorrencia::PagCore.reset
      PagseguroRecorrencia::PagCore.configure do |config|
        config.credential_email = 'test@test.com'
        config.credential_token = '5A9045945CD85239E8F8BDF34532DBA460'
        config.environment = :sandbox
        config.cancel_url = nil
      end
  
  
      builded_url = PagseguroRecorrencia::PagRequests::RequestApplication.new.url_environment(PagseguroRecorrencia::PagCore.configuration, :new_plan)
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
  
      builded_url = PagseguroRecorrencia::PagRequests::RequestApplication.new.url_environment(PagseguroRecorrencia::PagCore.configuration, :new_plan)
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
  
      expect { PagseguroRecorrencia::PagRequests::RequestApplication.new.url_environment(PagseguroRecorrencia::PagCore.configuration, :new_plan) }
        .to raise_error(StandardError, '[WRONG_ENVIRONMENT] environment: receive only (:sandbox :production), you pass :wrog_environment')     
    end
  end

  context 'when call parse_xml_to_hash() method' do
    it 'pass correct XML data and return Hash' do
      xml = '<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?><preApprovalRequest><preApproval><name>TEST - 1</name></preApproval></preApprovalRequest>'
      xml_parsed = PagseguroRecorrencia::PagRequests::RequestApplication.new.parse_xml_to_hash(xml)
      
      expect(xml_parsed.class).to eq(Hash)
      expect(xml_parsed.key?(:pre_approval_request)).to be_truthy
      expect(xml_parsed[:pre_approval_request].key?(:pre_approval)).to be_truthy
      expect(xml_parsed[:pre_approval_request][:pre_approval].key?(:name)).to be_truthy

      expect(xml_parsed[:pre_approval_request].class).to eq(Hash)
      expect(xml_parsed[:pre_approval_request][:pre_approval].class).to eq(Hash)
      expect(xml_parsed[:pre_approval_request][:pre_approval][:name].class).to eq(String)
      expect(xml_parsed[:pre_approval_request][:pre_approval][:name]).to eq('TEST - 1')
    end

    it 'pass wrong XML data missing close tag </name> and return raise' do
      xml = '<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?><preApprovalRequest><preApproval><name>TEST - 1</preApproval></preApprovalRequest>'
      expect { PagseguroRecorrencia::PagRequests::RequestApplication.new.parse_xml_to_hash(xml) }.to raise_error(StandardError)
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
      expect( PagseguroRecorrencia::PagRequests::RequestApplication.new.check_required_payload_presencies(payload, required_params) ).to be_truthy
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
      expect { PagseguroRecorrencia::PagRequests::RequestApplication.new.check_required_payload_presencies(payload, required_params) }.to raise_error(StandardError, '[MISSING_PAYLOAD_FIELD] :plan_name')
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
      expect { PagseguroRecorrencia::PagRequests::RequestApplication.new.check_required_payload_presencies(payload, required_params) }.to raise_error(StandardError, '[MISSING_PAYLOAD_FIELD] :charge_type')
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
      expect { PagseguroRecorrencia::PagRequests::RequestApplication.new.check_required_payload_presencies(payload, required_params) }.to raise_error(StandardError, '[MISSING_PAYLOAD_FIELD] :amount_per_payment')
    end

    it 'pass incorrect payload data' do
      payload = ["asd", 123]

      required_params = %i[ plan_name charge_type amount_per_payment ]
      expect { PagseguroRecorrencia::PagRequests::RequestApplication.new.check_required_payload_presencies(payload, required_params) }.to raise_error(RuntimeError)
    end
  end

  it 'when call request_route() method passing :new_plan' do
    result = PagseguroRecorrencia::PagRequests::RequestApplication.new.request_route(:new_plan)
    expect(result.class).to eq(String)
    expect(result).to eq('/pre-approvals/request?')
  end

  it 'when call request_route() method passing :new_session' do
    result = PagseguroRecorrencia::PagRequests::RequestApplication.new.request_route(:new_session)
    expect(result.class).to eq(String)
    expect(result).to eq('/v2/sessions?')
  end

  it 'when call header_content_type() method :form with param' do
    content_type_header = :form
    result = PagseguroRecorrencia::Builds::Header.header_content_type(content_type_header)
    expect(result.class).to eq(String)
    expect(result).to eq('application/x-www-form-urlencoded')
  end

  it 'when call header_content_type() method passing format and charset' do
    content_type_header = {
      format: 'json',
      charset: 'UTF-8'
    }
    result = PagseguroRecorrencia::Builds::Header.header_content_type(content_type_header)
    expect(result.class).to eq(String)
    expect(result).to eq('application/json;charset=UTF-8')
  end

  it 'when call header_accept() method passing format and charset' do
    accept_header = {
      format: 'json',
      charset: 'UTF-8'
    }
    result = PagseguroRecorrencia::Builds::Header.header_accept(accept_header)
    expect(result.class).to eq(String)
    expect(result).to eq('application/vnd.pagseguro.com.br.v3+json;charset=UTF-8')
  end

  
end

