require 'sinatra/base'
require_relative 'helpers/helper'

class FakePagseguro < Sinatra::Base
  post '/pre-approvals/request' do
    file = nil
    response_status = nil

    if request.body.string.content_around('<name>', '</name>').empty?
      file = 'new_plan_without_name.xml'
      response_status = 400
    elsif request.body.string.content_around('<charge>', '</charge>').empty?
      file = 'new_plan_without_name.xml'
      response_status = 400
    elsif request.body.string.content_around('<amountPerPayment>', '</amountPerPayment>').empty?
      file = 'new_plan_without_amount_per_payment.xml'
      response_status = 400
    else
      file = 'new_plan_success.xml'
      response_status = 200
    end

    response_request response_status, file
  end

  post '/v2/sessions' do
    file = 'new_session_success.xml'
    response_status = 200

    file = 'new_session_wrong_credentials.xml' if request.params['email'] == 'wrong@wrong.com'
    response_status = 401 if request.params['email'] == 'wrong@wrong.com'

    response_request response_status, file
  end

  post '/v2/cards' do
    file = nil
    response_status = 200
    
    if params['sessionId'] != '' && params['cardNumber'] == '5132103426888543'
      file = 'new_card_token_success.xml'
    elsif params['sessionId'] != '' && params['cardNumber'].length != 16
      file = 'new_card_token_invalid_credit_card_data.xml'
    else
      file = 'new_card_token_invalid_session_id.xml'
    end
    
    response_request response_status, file
  end

  get '/df-fe/mvc/creditcard/v1/getBin' do
    file = nil
    response_status = 200
    return_type = :json

    if params['creditCard'] != '454545' && params['tk'] == '6697c5ddac4f4d20bf310ded7d168175'
      file = 'get_card_brand_success.json'
    elsif params['creditCard'] == '454545' && params['tk'] == '6697c5ddac4f4d20bf310ded7d168175'
      file = 'get_card_brand_wrong_bin.json'
    else
      file = 'get_card_brand_invalid_session.json'
    end

    response_request response_status, file, return_type
  end

  private

  def response_request(response_code, file_name, return_type = :xml)
    content_type return_type
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end
