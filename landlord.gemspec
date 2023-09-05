require_relative "lib/landlord/version"

Gem::Specification.new do |spec|
  spec.name        = "landlord"
  spec.version     = Landlord::VERSION
  spec.authors     = ["Nazareno Moresco"]
  spec.email       = ["nazareno.moresco@sinaptia.dev"]
  spec.homepage    = "https://github.com/sinaptia/landlord"
  spec.summary     = "A dynamic and hybrid multitenancy solution for Rails > 6.0 & PostgresSQL"
  spec.description = "A dynamic and hybrid multitenancy solution for Rails > 6.0 & PostgresSQL"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 6.0"
end
