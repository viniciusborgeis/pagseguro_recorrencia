require 'spec_helper'
require 'support/helpers/helper'

RSpec.describe PagseguroRecorrencia::Configuration do
  it 'when pass configuration fully' do
    configuration = PagseguroRecorrencia::Configuration.new
    configuration.credential_email = 'test@gmail.com'
    configuration.credential_token = 'ASDASF2131231FASD23123'
    configuration.environment = :sandbox
    configuration.cancel_url = 'http://test.com.br'

    expect(configuration.credential_email.class).to eq(String)
    expect(configuration.credential_token.class).to eq(String)
    expect(configuration.environment.class).to eq(Symbol)
    expect(configuration.cancel_url.class).to eq(String)

    expect(configuration.credential_email).to eq('test@gmail.com')
    expect(configuration.credential_token).to eq('ASDASF2131231FASD23123')
    expect(configuration.environment).to eq(:sandbox)
    expect(configuration.cancel_url).to eq('http://test.com.br')
  end
end
