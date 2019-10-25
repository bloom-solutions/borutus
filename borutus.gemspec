$LOAD_PATH.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "borutus/version"
require "date"

Gem::Specification.new do |s|
  s.name = "borutus"
  s.version = Borutus::VERSION
  s.authors = ["Ramon Tayag", "Ace Subido"]
  s.email = ["ramon.tayag@gmail.com", "ace.subido@gmail.com"]
  s.homepage = "http://github.com/bloom-solutions/borutus"
  s.date = Date.today
  s.summary = "A Plugin providing a Double Entry Accounting Engine for Rails"
  s.description = %(
    The borutus plugin provides a complete double entry accounting system for
    use in any Ruby on Rails application. The plugin follows general Double
    Entry Bookkeeping practices. All calculations are done using BigDecimal
    in order to prevent floating point rounding errors. The plugin requires
    a decimal type on your database as well.
  %)

  s.files = Dir["{app,config,db,lib}/**/*"] + %w[LICENSE Rakefile README.md]
  s.test_files = Dir["{spec}/**/*"]
  s.require_paths = %w[lib]
  s.extra_rdoc_files = %w[LICENSE README.md]

  version = if s.respond_to? :required_rubygems_version=
              Gem::Requirement.new(">= 0")
            end

  s.required_rubygems_version = version

  s.add_dependency "jquery-rails", ">= 3.0"
  s.add_dependency "jquery-ui-rails", ">= 4.2.2"
  s.add_dependency "kaminari", "~> 1.0"
  s.add_dependency "light-service", ">= 0.11.0"
  s.add_dependency "rails", "> 4.0"

  s.add_development_dependency "shoulda-matchers"
  s.add_development_dependency "yard"

  s.specification_version = 3 if s.respond_to? :specification_version
end
