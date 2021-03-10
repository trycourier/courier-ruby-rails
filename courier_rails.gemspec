# frozen_string_literal: true

require_relative "lib/courier_rails/version"

Gem::Specification.new do |spec|
  spec.name = "courier_rails"
  spec.version = CourierRails::VERSION
  spec.authors = ["Aydrian Howard"]
  spec.email = ["aydrian@courier.com"]

  spec.summary = "Courier for Rails"
  spec.description = "Delivery Method for Rails ActionMailer to send notifications using the Courier API"
  spec.homepage = "https://github.com/trycourier/courier-ruby-rails"
  spec.license = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/trycourier/courier-ruby-rails"
  spec.metadata["changelog_uri"] = "https://github.com/trycourier/courier-ruby-rails/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  # spec.add_dependency "rails", ">= 4.0", "< 6.1"
  spec.add_dependency "rails", "~> 6.0.0"
  spec.add_dependency "trycourier"

  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "webmock", ">=1.24.2"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
