require 'spec_helper'
require 'support/helpers/helper'

RSpec.describe PagseguroRecorrencia::PagCore do
  it 'when call configuration() method without set configuration befored' do
    PagseguroRecorrencia::PagCore.reset
    result = PagseguroRecorrencia::PagCore.configuration
    expect(result.class).to eq(PagseguroRecorrencia::Configuration)
    expect(result.credential_email).to be_nil
    expect(result.credential_token).to be_nil
    expect(result.environment).to be_nil
    expect(result.cancel_url).to be_nil
  end

  it 'when call the configuration() method after setting the configuration' do
    PagseguroRecorrencia::PagCore.configure do |config|
      config.credential_email = 'test@test.com'
      config.credential_token = '5A9045945CD85239E8F8BDF34532DBA460'
      config.environment = :sandbox
      config.cancel_url = 'http://test.com.br'
    end

    result = PagseguroRecorrencia::PagCore.configuration
    expect(result.class).to eq(PagseguroRecorrencia::Configuration)
    expect(result.credential_email).to eq('test@test.com')
    expect(result.credential_token).to eq('5A9045945CD85239E8F8BDF34532DBA460')
    expect(result.environment).to eq(:sandbox)
    expect(result.cancel_url).to eq('http://test.com.br')
  end

  it 'when call the reset() method after setting the configuration return new configuration reseted' do
    PagseguroRecorrencia::PagCore.configure do |config|
      config.credential_email = 'test@test.com'
      config.credential_token = '5A9045945CD85239E8F8BDF34532DBA460'
      config.environment = :sandbox
      config.cancel_url = 'http://test.com.br'
    end

    result = PagseguroRecorrencia::PagCore.reset
    expect(result.class).to eq(PagseguroRecorrencia::Configuration)
    expect(result.credential_email).to be_nil
    expect(result.credential_token).to be_nil
    expect(result.environment).to be_nil
    expect(result.cancel_url).to be_nil
  end
end
