require 'sinatra/base'
require_relative 'helpers/helper'

class FakePagseguro < Sinatra::Base
  post '/pre-approvals/request' do
    file = nil
    response_status = nil
    return_type = :xml

    req_body = request.body.string

    tag_name_exist_and_is_empty = (req_body.include?("<name>") && req_body.content_around('<name>', '</name>').empty?)
    tag_name_not_exist = (!req_body.include?("<name>"))
    
    tag_charge_exist_and_is_empty = (req_body.include?("<charge>") && req_body.content_around('<charge>', '</charge>').empty?)
    tag_charge_not_exist = (!req_body.include?("<charge>"))

    tag_amount_per_payment_exist_and_is_empty = (req_body.include?("<amountPerPayment>") && req_body.content_around('<amountPerPayment>', '</amountPerPayment>').empty?)
    tag_amount_per_payment_not_exist = (!req_body.include?("<amountPerPayment>"))

    if tag_name_exist_and_is_empty || tag_name_not_exist
      file = 'new_plan_without_name.xml'
      response_status = 400
    elsif tag_charge_exist_and_is_empty || tag_charge_not_exist
      file = 'new_plan_without_charge.xml'
      response_status = 400
    elsif tag_amount_per_payment_exist_and_is_empty || tag_amount_per_payment_not_exist
      file = 'new_plan_without_amount_per_payment.xml'
      response_status = 400
    elsif req_body.content_around('<name>', '</name>') == '404'
      file = '404.html'
      response_status = 404
      return_type = :html
    elsif req_body.content_around('<name>', '</name>') == '500'
      file = '500.html'
      response_status = 500
      return_type = :html
    else
      file = 'new_plan_success.xml'
      response_status = 200
    end

    response_request response_status, file, return_type
  end

  post '/v2/sessions' do
    file = nil
    response_status = 200
    return_type = :xml

    if request.params['email'] == '404'
      file = '404.html'
      response_status = 404
      return_type = :html
    elsif request.params['email'] == 'wrong@wrong.com'
      file = 'new_session_wrong_credentials.xml'
      response_status = 401
    else
      file = 'new_session_success.xml'
    end

    response_request response_status, file, return_type
  end

  post '/v2/cards' do
    file = nil
    response_status = 200
    return_type = :xml

    if params['sessionId'] != '' && params['cardNumber'] == '404'
      file = '404.html'
      response_status = 404
      return_type = :html
    elsif params['sessionId'] != '' && params['cardNumber'] == '5132103426888543'
      file = 'new_card_token_success.xml'
    elsif params['sessionId'] != '' && params['cardNumber'].length != 16
      file = 'new_card_token_invalid_credit_card_data.xml'
    else
      file = 'new_card_token_invalid_session_id.xml'
    end
    
    response_request response_status, file, return_type
  end

  get '/df-fe/mvc/creditcard/v1/getBin' do
    file = nil
    response_status = 200
    return_type = :json


    if params['creditCard'] == '404'
      file = '404.html'
      response_status = 404
      return_type = :html
    elsif params['creditCard'] != '454545' && params['tk'] == '6697c5ddac4f4d20bf310ded7d168175'
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
