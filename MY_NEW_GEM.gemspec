Gem::Specification.new do |s|
  s.authors     = ["Daniel Pepper"]
  s.description = "..."
  s.files       = `git ls-files * ':!:spec'`.split("\n")
  s.homepage    = "https://github.com/dpep/MY_NEW_REPO"
  s.license     = "MIT"
  s.name        = File.basename(__FILE__, ".gemspec")
  s.summary     = "MY_NEW_GEM"
  s.version     = "0.0.0"

  s.required_ruby_version = ">= 3"

  s.add_development_dependency 'byebug', '>= 11'
  s.add_development_dependency 'rspec', '>= 3.10'
  s.add_development_dependency 'simplecov', '>= 0.22'
end
