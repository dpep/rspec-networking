require_relative "lib/rspec/networking/version"

Gem::Specification.new do |s|
  s.authors     = ["Daniel Pepper"]
  s.description = "RSpec matchers for IP and MAC Addresses"
  s.files       = `git ls-files * ':!:spec'`.split("\n")
  s.homepage    = "https://github.com/dpep/rspec-networking"
  s.license     = "MIT"
  s.name        = "rspec-networking"
  s.summary     = "RSpec::Networking"
  s.version     = RSpec::Networking::VERSION

  s.required_ruby_version = ">= 3"

  s.add_dependency "rspec-expectations", ">= 3"

  s.add_development_dependency "debug"
  s.add_development_dependency "faker"
  s.add_development_dependency "rspec"
  s.add_development_dependency "simplecov"
end
