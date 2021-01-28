require 'spec_helper'
require 'support/helpers/helper'
require 'support/stubs_data/new_plan'

RSpec.describe PagseguroRecorrencia::PagRequests::NewPlan do


  it 'when call create() method passing payload' do
    PagseguroRecorrencia::PagCore.configure do |config|
      config.credential_email = 'test@test.com'
      config.credential_token = '5A9045945CD85239E8F8BDF34532DBA460'
      config.environment = :sandbox
      config.cancel_url = nil
    end
    
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
    result = PagseguroRecorrencia::PagRequests::NewPlan.new.create payload
    
    expect(result.class).to eq(Hash)
    expect(result.key?(:code)).to be_truthy
    expect(result.key?(:message)).to be_truthy
    expect(result.key?(:body)).to be_truthy
    expect(result[:body].key?(:code)).to be_truthy
    expect(result[:body].key?(:date)).to be_truthy

    expect(result[:code].class).to be(String)
    expect(result[:message].class).to be(String)
    expect(result[:body].class).to be(Hash)

    expect(result[:body][:code].class).to be(String)
    expect(result[:body][:date].class).to be(String)


    expect(result[:code]).to eq("200")
    expect(result[:message]).to eq("OK")
    expect(result[:body][:code]).to eq("5A408BD29494B1523E4AA4F21124198897ADE2")
    expect(result[:body][:date]).to eq("2021-01-27T01:42:25-03:00")
  end

  it 'when call create() method without pass payload' do
    PagseguroRecorrencia::PagCore.configure do |config|
      config.credential_email = 'test@test.com'
      config.credential_token = '5A9045945CD85239E8F8BDF34532DBA460'
      config.environment = :sandbox
      config.cancel_url = nil
    end
    expect { PagseguroRecorrencia::PagRequests::NewPlan.new.create }.to raise_error(ArgumentError, 'wrong number of arguments (given 0, expected 1)')
  end

  it 'when call create() method without set configuration befored' do
    PagseguroRecorrencia::PagCore.reset
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
    expect { PagseguroRecorrencia::PagRequests::NewPlan.new.create(payload) }.to raise_error(RuntimeError, '[WRONG_ENVIRONMENT] environment: receive only (:sandbox :production), you pass :')
  end

end
