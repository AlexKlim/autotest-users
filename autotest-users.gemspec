# -*- encoding: utf-8 -*-
require File.expand_path('../lib/autotest-users/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Alex Klimenkov"]
  gem.email         = ["alex.klimenkov89@gmail.com"]
  gem.description   = %q{Gem for provide user for autotest}
  gem.summary       = %q{Gem create, update, save some params for users. All users are saved in the Hash and will available, when automated test is running. Users are not saved into database. Today it is not needed.}
  gem.homepage      = "https://github.com/AlexKlim/autotest-users"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "autotest-users"
  gem.require_paths = ["lib"]
  gem.version       = Autotest::Users::VERSION
  gem.add_dependency("randexp")

end
