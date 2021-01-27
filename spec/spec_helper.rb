require 'bundler/setup'
require 'simplecov'
SimpleCov.start do
  add_filter '/test/'
  add_filter '/spec/'
  track_files '{lib}/**/*.rb'
end

require 'pagseguro_recorrencia'
require 'webmock/rspec'
require 'pry-byebug'
require_relative 'support/fake_pagseguro'

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.before(:each) do
    stub_request(:any, /ws.sandbox.pagseguro.uol.com.br/).to_rack(FakePagseguro)
  end
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
