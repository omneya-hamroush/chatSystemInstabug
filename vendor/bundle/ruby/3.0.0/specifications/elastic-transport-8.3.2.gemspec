# -*- encoding: utf-8 -*-
# stub: elastic-transport 8.3.2 ruby lib

Gem::Specification.new do |s|
  s.name = "elastic-transport".freeze
  s.version = "8.3.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "https://github.com/elastic/elastic-transport-ruby/issues", "changelog_uri" => "https://github.com/elastic/elastic-transport-ruby/blob/master/CHANGELOG.md", "homepage_uri" => "https://github.com/elastic/elastic-transport-ruby", "source_code_uri" => "https://github.com/elastic/elastic-transport-ruby" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Elastic Client Library Maintainers".freeze]
  s.date = "2024-02-14"
  s.description = "Low level Ruby client for Elastic. See the `elasticsearch` or `elastic-enterprise-search` gems for full integration.\n".freeze
  s.email = ["client-libs@elastic.co".freeze]
  s.extra_rdoc_files = ["README.md".freeze, "LICENSE".freeze]
  s.files = ["LICENSE".freeze, "README.md".freeze]
  s.homepage = "https://github.com/elastic/elastic-transport-ruby".freeze
  s.licenses = ["Apache-2.0".freeze]
  s.rdoc_options = ["--charset=UTF-8".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.5".freeze)
  s.rubygems_version = "3.3.5".freeze
  s.summary = "Low level Ruby client for Elastic services.".freeze

  s.installed_by_version = "3.3.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<faraday>.freeze, ["< 3"])
    s.add_runtime_dependency(%q<multi_json>.freeze, [">= 0"])
    s.add_development_dependency(%q<curb>.freeze, [">= 0"])
    s.add_development_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_development_dependency(%q<cane>.freeze, [">= 0"])
    s.add_development_dependency(%q<hashie>.freeze, [">= 0"])
    s.add_development_dependency(%q<minitest>.freeze, [">= 0"])
    s.add_development_dependency(%q<minitest-reporters>.freeze, [">= 0"])
    s.add_development_dependency(%q<mocha>.freeze, [">= 0"])
    s.add_development_dependency(%q<pry>.freeze, [">= 0"])
    s.add_development_dependency(%q<rake>.freeze, ["~> 13"])
    s.add_development_dependency(%q<require-prof>.freeze, [">= 0"])
    s.add_development_dependency(%q<ruby-prof>.freeze, [">= 0"])
    s.add_development_dependency(%q<shoulda-context>.freeze, [">= 0"])
    s.add_development_dependency(%q<simplecov>.freeze, [">= 0"])
    s.add_development_dependency(%q<test-unit>.freeze, ["~> 2"])
    s.add_development_dependency(%q<yard>.freeze, [">= 0"])
  else
    s.add_dependency(%q<faraday>.freeze, ["< 3"])
    s.add_dependency(%q<multi_json>.freeze, [">= 0"])
    s.add_dependency(%q<curb>.freeze, [">= 0"])
    s.add_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_dependency(%q<cane>.freeze, [">= 0"])
    s.add_dependency(%q<hashie>.freeze, [">= 0"])
    s.add_dependency(%q<minitest>.freeze, [">= 0"])
    s.add_dependency(%q<minitest-reporters>.freeze, [">= 0"])
    s.add_dependency(%q<mocha>.freeze, [">= 0"])
    s.add_dependency(%q<pry>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, ["~> 13"])
    s.add_dependency(%q<require-prof>.freeze, [">= 0"])
    s.add_dependency(%q<ruby-prof>.freeze, [">= 0"])
    s.add_dependency(%q<shoulda-context>.freeze, [">= 0"])
    s.add_dependency(%q<simplecov>.freeze, [">= 0"])
    s.add_dependency(%q<test-unit>.freeze, ["~> 2"])
    s.add_dependency(%q<yard>.freeze, [">= 0"])
  end
end
