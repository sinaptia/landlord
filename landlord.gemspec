Gem::Specification.new do |s|
  s.name        = "landlord"
  s.version     = "0.1.0"
  s.summary     = "A dynamic and hybrid multitenancy solution for Rails > 6.0 & PostgresSQL"
  s.description = "A dynamic and hybrid multitenancy solution for Rails > 6.0 & PostgresSQL"
  s.authors     = ["Nazareno Moresco"]
  s.email       = "nazareno.moresco@sinaptia.dev"
  s.files       =  Dir["lib/**/*"]
  s.homepage    =
    "https://rubygems.org/gems/landlord"
  s.license       = "MIT"

  s.add_dependency 'rails', '~> 6.1'
end

  