# -*- encoding: utf-8 -*-
require File.expand_path('../lib/roleable/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Mitch Crowe"]
  gem.email         = ["crowe.mitch@gmail.com"]
  gem.description   = %q{Roles solution for active-record-backed Rails 3 applications}
  gem.summary       = %q{Roles solution for active-record-backed Rails 3 applications}
  gem.homepage      = "https://github.com/mcrowe/roleable"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "roleable"
  gem.require_paths = ["lib"]
  gem.version       = Roleable::VERSION

  gem.add_development_dependency 'rake', '~> 0.9'
  gem.add_development_dependency 'rspec', '~> 2.8'
  gem.add_development_dependency 'sqlite3', '~> 1.3'
  gem.add_development_dependency 'activerecord', '~> 3.0'
  gem.add_development_dependency 'with_model', '~> 0.2'
end
