require_relative "lib/landlord/version"

Gem::Specification.new do |spec|
  spec.name = "landlord"
  spec.version = Landlord::VERSION
  spec.authors     = ["Nazareno Moresco"]
  spec.email       = "nazareno.moresco@sinaptia.dev"
  spec.summary     = "A dynamic and hybrid multitenancy solution for Rails > 6.0 & PostgresSQL"
  spec.description = "A dynamic and hybrid multitenancy solution for Rails > 6.0 & PostgresSQL"
  spec.homepage = "https://rubygems.org/gems/landlord"
  spec.required_ruby_version = ">= 2.6.0"

  spec.license       = "MIT"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/sinaptia/landlord"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency 'rails', '>= 6.0'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
