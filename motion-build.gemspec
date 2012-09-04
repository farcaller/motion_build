# -*- encoding: utf-8 -*-
require File.expand_path('../lib/motion_build/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Vladimir Pouzanov"]
  gem.email         = ["farcaller@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "motion_build"
  gem.require_paths = ["lib"]
  gem.version       = Motion::Build::VERSION

  gem.add_development_dependency 'rspec'
  gem.add_runtime_dependency 'CFPropertyList'
  gem.add_runtime_dependency 'uuidtools'
  gem.add_runtime_dependency 'term-ansicolor'
end
