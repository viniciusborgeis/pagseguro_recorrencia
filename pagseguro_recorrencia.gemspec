require_relative 'lib/pagseguro_recorrencia/version'

Gem::Specification.new do |spec|
  spec.name          = 'pagseguro_recorrencia'
  spec.version       = PagseguroRecorrencia::VERSION
  spec.authors       = ['Vinicius Borges']
  spec.email         = ['viniciusborgeis@gmail.com']

  spec.summary       = 'REST API integration for pagseguro recurrence payment'
  spec.description   = 'REST API integration for pagseguro recurrence payment'
  spec.homepage      = 'https://github.com/viniciusborgeis'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.4.0')

  spec.metadata['allowed_push_host'] = 'http://mygemserver.com'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/viniciusborgeis/pagseguro_recorrencia.git'
  # spec.metadata["changelog_uri"] = "README.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.files.push(
    'lib/pagseguro_recorrencia/configuration.rb',
    'lib/pagseguro_recorrencia/source/core/pag_core.rb',
    'lib/pagseguro_recorrencia/source/helpers/pag_helpers.rb',
    'lib/pagseguro_recorrencia/source/requests/pag_new_plan.rb',
    'lib/pagseguro_recorrencia/source/requests/bodies/body_new_plan.rb'
  )
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.add_dependency('activesupport', '~> 4.2', '>= 4.2.6')
  spec.add_dependency('json', '2.3.0')
  spec.add_dependency('ruby-enum', '~> 0.8.0')
end
