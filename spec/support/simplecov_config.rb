require 'simplecov'
SimpleCov.start do
  add_filter '/test/'
  add_filter '/spec/'
  add_filter 'lib/pagseguro_recorrencia/version.rb'
  track_files '{lib}/**/*.rb'
end
require 'shields_badge'
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::ShieldsBadge
])