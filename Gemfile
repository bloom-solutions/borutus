source "http://rubygems.org"

# Specify your gem's dependencies in borutus.gemspec
gemspec

group :development, :test do
  gem "activerecord-jdbcsqlite3-adapter", require: "jdbc-sqlite3", platform: :jruby
  gem "bloom_rubocop", "0.2.0"
  gem "coveralls", require: false
  gem "factory_bot_rails", "~> 5.1"
  gem "jdbc-sqlite3", platform: :jruby
  gem "pry-byebug"
  gem "rails-controller-testing"
  gem "rspec", "~> 3"
  gem "rspec-its"
  gem "rspec-rails", "~> 3"
  gem "sqlite3", :platform => [:ruby, :mswin, :mingw]
  gem "pg", "~> 1.1"
end
