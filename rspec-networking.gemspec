require_relative "lib/rspec/networking/version"
package = RSpec::Networking
package_name = "rspec-networking"

Gem::Specification.new do |s|
  s.authors     = ["Daniel Pepper"]
  s.description = "RSpec matchers for IP and MAC Addresses"
  s.files       = `git ls-files * ':!:spec'`.split("\n")
  s.homepage    = "https://github.com/dpep/#{package_name}"
  s.license     = "MIT"
  s.name        = package_name
  s.summary     = package.to_s
  s.version     = package.const_get "VERSION"

  s.required_ruby_version = ">= 3"

  s.add_dependency "rspec-expectations", ">= 3"
  s.add_dependency "ipaddr"

  s.add_development_dependency "byebug"
  s.add_development_dependency "faker"
  s.add_development_dependency "rspec"
  s.add_development_dependency "simplecov"
end
