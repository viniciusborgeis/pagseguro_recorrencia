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