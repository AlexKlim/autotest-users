# -*- encoding: utf-8 -*-
require File.expand_path('../lib/autotest-users/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Alex Klimenkov"]
  gem.email         = ["alex.klimenkov89@gmail.com"]
  gem.description   = %q{A gem description}
  gem.summary       = %q{A gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "autotest-users"
  gem.require_paths = ["lib"]
  gem.version       = Autotest::Users::VERSION
end
