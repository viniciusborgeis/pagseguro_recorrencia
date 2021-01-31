require_relative '../support/helpers/helper'

RSpec.describe PagseguroRecorrencia do
  let!(:payload) { new_plan_payload }
  before(:each) do
    new_configuration
  end

  context 'when call new_plan() method' do
    it 'when request all fields return success' do
      response = PagseguroRecorrencia.new_plan(payload)
      expect(response.class).to eq(Hash)
      expect(response.key?(:code)).to be_truthy
      expect(response.key?(:message)).to be_truthy
      expect(response.key?(:body)).to be_truthy
      expect(response[:body].key?(:code)).to be_truthy
      expect(response[:body].key?(:date)).to be_truthy

      expect(response[:code]).to eq('200')
      expect(response[:message]).to eq('OK')
      expect(response[:body][:code]).to eq('5A408BD29494B1523E4AA4F21124198897ADE2')
      expect(valid_date?(response[:body][:date])).to equal true
    end

    it 'when request all fields with empty :plan_name return error' do
      tmp_payload = payload
      tmp_payload[:plan_name] = ''
      response = PagseguroRecorrencia.new_plan(tmp_payload)

      expect(response.class).to eq(Hash)
      expect(response.key?(:code)).to be_truthy
      expect(response.key?(:message)).to be_truthy
      expect(response.key?(:body)).to be_truthy
      expect(response[:body].key?(:error)).to be_truthy
      expect(response[:body][:error].key?(:code)).to be_truthy
      expect(response[:body][:error].key?(:message)).to be_truthy

      expect(response[:body][:error][:code]).to eq('11088')
      expect(response[:body][:error][:message]).to eq('preApprovalName is required')
    end

    it 'when request all fields with empty :plan_charge return raise error' do
      tmp_payload = payload
      tmp_payload[:charge_type] = ''
      expect do
        PagseguroRecorrencia.new_plan(tmp_payload)
      end.to raise_error(StandardError,
                         '[VALUE_ERROR] :charge_type can only receive these values (:manual, :auto)')
    end

    it 'when request all fields with empty :amount_per_payment return error' do
      tmp_payload = payload
      tmp_payload[:amount_per_payment] = ''
      response = PagseguroRecorrencia.new_plan(tmp_payload)

      expect(response.class).to eq(Hash)
      expect(response.key?(:code)).to be_truthy
      expect(response.key?(:message)).to be_truthy
      expect(response.key?(:body)).to be_truthy
      expect(response[:body].key?(:error)).to be_truthy
      expect(response[:body][:error].key?(:code)).to be_truthy
      expect(response[:body][:error].key?(:message)).to be_truthy

      expect(response[:body][:error][:code]).to eq('11106')
      expect(response[:body][:error][:message]).to eq('preApprovalAmountPerPayment invalid value.')
    end

    it 'when request return 404 not found' do
      tmp_payload = payload
      tmp_payload[:plan_name] = '404' # only for sinatra fake_pagseguro match
      response = PagseguroRecorrencia.new_plan(tmp_payload)

      expect(response.class).to eq(Hash)
      expect(response.key?(:code)).to be_truthy
      expect(response.key?(:message)).to be_truthy
      expect(response.key?(:body)).to be_truthy

      expect(response[:code]).to eq('404')
      expect(response[:message]).to eq('Not Found')
      expect(response[:body]).to be_nil
    end

    it 'when request return 500 internal server error' do
      tmp_payload = payload
      tmp_payload[:plan_name] = '500' # only for sinatra fake_pagseguro match
      response = PagseguroRecorrencia.new_plan(tmp_payload)

      expect(response.class).to eq(Hash)
      expect(response.key?(:code)).to be_truthy
      expect(response.key?(:message)).to be_truthy
      expect(response.key?(:body)).to be_truthy
      expect(response[:code]).to eq('500')
      expect(response[:message]).to eq('Internal Server Error')
      expect(response[:body]).to eq('ERROR 500 - Internal Server Error')
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
      expect do
        PagseguroRecorrencia::PagRequests::NewPlan.new.create(payload)
      end.to raise_error(RuntimeError,
                         '[WRONG_ENVIRONMENT] environment: receive only (:sandbox :production), you pass :')
    end
  end
end
