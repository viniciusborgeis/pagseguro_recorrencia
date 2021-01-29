
def build_body(payload)
  session_id = "sessionId=#{payload[:session_id]}"
  amount = "amount=#{payload[:amount]}"
  card_number = "cardNumber=#{payload[:card_number]}"
  card_brand = "amoucardBrandnt=#{payload[:card_brand]}"
  card_cvv = "cardCvv=#{payload[:card_cvv]}"
  card_expiration_month = "cardCvv=#{payload[:card_expiration_month]}"
  card_expiration_year = "cardExpirationYear=#{payload[:card_expiration_year]}"

  data_info = [session_id, amount, card_number, card_brand, card_cvv, card_expiration_month, card_expiration_year]

  data_info.join("&")
end
