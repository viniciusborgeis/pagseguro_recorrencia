require_relative '../support/helpers/helper'

RSpec.describe PagseguroRecorrencia do
  let!(:payload) { new_card_token_payload }
  before(:each) do
    new_configuration
  end

  context 'when call new_card_token() method' do
    it 'when pass a success payload data' do
      response = PagseguroRecorrencia.new_card_token(payload)
      expect(response.class).to eq(Hash)
      expect(response.key?(:code)).to be_truthy
      expect(response.key?(:message)).to be_truthy
      expect(response.key?(:body)).to be_truthy
      expect(response[:body].key?(:card)).to be_truthy
      expect(response[:body][:card].key?(:token)).to be_truthy

      expect(response[:code]).to eq('200')
      expect(response[:message]).to eq('OK')
      expect(response[:body][:card][:token]).to eq('2ded2e607fc347c995918ca8bba5a1f4')
    end

    it 'when pass a invalid credit card number in payload data' do
      payload[:card_number] = "000000"
      response = PagseguroRecorrencia.new_card_token(payload)
      expect(response.class).to eq(Hash)
      expect(response.key?(:code)).to be_truthy
      expect(response.key?(:message)).to be_truthy
      expect(response.key?(:body)).to be_truthy
      expect(response[:body].key?(:error)).to be_truthy
      expect(response[:body][:error].key?(:code)).to be_truthy
      expect(response[:body][:error].key?(:message)).to be_truthy

      expect(response[:body][:error][:code]).to eq('30400')
      expect(response[:body][:error][:message]).to eq('invalid creditcard data')
    end
  end
end
