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

    xml_response response_status, file
  end

  private

  def xml_response(response_code, file_name)
    content_type :xml
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end
