require_relative '../support/helpers/helper'

RSpec.describe PagseguroRecorrencia do
  before(:each) do
    new_configuration
  end

  context 'when call new_session() method' do
    it 'when the settings were set' do
      response = PagseguroRecorrencia.new_session
      expect(response.class).to eq(Hash)
      expect(response.key?(:code)).to be_truthy
      expect(response.key?(:message)).to be_truthy
      expect(response.key?(:body)).to be_truthy
      expect(response[:body].key?(:session)).to be_truthy
      expect(response[:body][:session].key?(:id)).to be_truthy

      expect(response[:code]).to eq("200");
      expect(response[:message]).to eq("OK");
      expect(response[:body][:session][:id]).to eq("6697c5ddac4f4d20bf310ded7d168175");
    end

    it 'when the credentials is wrong' do
      PagseguroRecorrencia::PagCore.reset
      PagseguroRecorrencia::PagCore.configure do |config|
        config.credential_email = 'wrong@wrong.com'
        config.credential_token = '5A9045945CD85239E8F8BDF34532DBA460'
        config.environment = :sandbox
        config.cancel_url = nil
      end
      response = PagseguroRecorrencia.new_session
      expect(response.class).to eq(Hash)

      expect(response[:code]).to eq("401");
      expect(response[:message]).to eq("Unauthorized");
      expect(response[:body]).to eq("Unauthorized");
    end
  end
end
