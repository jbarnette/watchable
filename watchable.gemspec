Gem::Specification.new do |gem|
  gem.authors       = ["John Barnette"]
  gem.email         = ["john@jbarnette.com"]
  gem.description   = "A simple event mixin, reluctantly extracted to a gem."
  gem.summary       = "Watch an object for events."
  gem.homepage      = "https://github.com/jbarnette/watchable"

  gem.files         = `git ls-files`.split "\n"
  gem.test_files    = `git ls-files -- test/*`.split "\n"
  gem.name          = "watchable"
  gem.require_paths = ["lib"]
  gem.version       = "0.0.1"

  gem.add_development_dependency "minitest", "~> 4.6"
  gem.add_development_dependency "mocha",    "~> 0.13"
end
