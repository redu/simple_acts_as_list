# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_acts_as_list/version'

Gem::Specification.new do |gem|
  gem.name          = "simple_acts_as_list"
  gem.version       = SimpleActsAsList::VERSION
  gem.authors       = ["Juliana Lucena"]
  gem.email         = ["julianalucenaa@gmail.com"]
  gem.description   = %q{Provides a very simple list behavior based on a scope.}
  gem.summary       = %q{Provides a very simple list behavior based on a scope.}
  gem.homepage      = "https://github.com/redu/simple_acts_as_list"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^spec/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'activesupport'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'sqlite3'
  gem.add_development_dependency 'activerecord'
end
