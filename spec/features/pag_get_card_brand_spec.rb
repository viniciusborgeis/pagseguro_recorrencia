require_relative '../support/helpers/helper'

RSpec.describe PagseguroRecorrencia do
  before(:each) do
    new_configuration
  end

  context 'when call get_card_brand() method' do
    it 'when pass a correct bin' do
      bin = '411111'
      response = PagseguroRecorrencia.get_card_brand(bin)
      expect(response.class).to eq(Hash)
      expect(response.key?(:code)).to be_truthy
      expect(response.key?(:message)).to be_truthy
      expect(response.key?(:body)).to be_truthy
      expect(response[:body].key?(:bin)).to be_truthy
      expect(response[:body][:bin].key?(:bin)).to be_truthy
      expect(response[:body][:bin].key?(:brand)).to be_truthy

      expect(response[:body][:bin][:bin]).to eq(411111)
      expect(response[:body][:bin][:brand][:name]).to eq('visa')
      expect(response[:body][:bin][:status_message]).to eq('Success')
    end

    it 'when pass a incorrect bin' do
      bin = '454545'
      response = PagseguroRecorrencia.get_card_brand(bin)
      expect(response.class).to eq(Hash)
      expect(response.key?(:code)).to be_truthy
      expect(response.key?(:message)).to be_truthy
      expect(response.key?(:body)).to be_truthy

      expect(response[:body][:status_message]).to eq('Error')
      expect(response[:body][:reason_message]).to eq('Bin not found')
    end
  end
end
