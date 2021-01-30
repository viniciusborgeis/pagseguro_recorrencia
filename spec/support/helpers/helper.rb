def valid_date?(date)
  date_format = '%Y-%m-%d'
  DateTime.strptime(date, date_format)
  true
rescue ArgumentError
  false
end

class String
  def content_around(marker1, marker2)
    self[/#{Regexp.escape(marker1)}(.*?)#{Regexp.escape(marker2)}/m, 1]
  end
end

def new_plan_payload
  {
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
end

def new_card_token_payload
  {
    amount: '100.00',
    card_number: '5132 1034 2688 8543',
    card_brand: 'mastercard',
    card_cvv: '534',
    card_expiration_month: '05'
  }
end

def new_configuration
  PagseguroRecorrencia::PagCore.reset
  PagseguroRecorrencia::PagCore.configure do |config|
    config.credential_email = 'test@test.com'
    config.credential_token = '5A9045945CD85239E8F8BDF34532DBA460'
    config.environment = :sandbox
    config.cancel_url = nil
    config.session_id = nil
  end
end