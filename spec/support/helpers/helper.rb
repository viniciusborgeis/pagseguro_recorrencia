def valid_date?(date)
  date_format = '%Y-%m-%d'
  DateTime.strptime(date, date_format)
  true
rescue ArgumentError
  false
end