# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.6.1"

gem "bootsnap", ">= 1.1.0", require: false
gem "devise"
gem "ingreedy"
gem "instacart_api", path: "../instacart_api"
gem "jbuilder", "~> 2.5"
gem "pg", ">= 0.18", "< 2.0"
gem "puma", "~> 3.11"
gem "rails", "~> 5.2.3"
gem "rubocop"
gem "sass-rails", "~> 5.0"
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :development, :test do
  gem "pre-commit"
  gem "pry"
  gem "pry-nav"
  gem "pry-rails"
end

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
end

group :test do
  gem "rspec-rails"
  gem "simplecov", require: false
  gem "webmock"
end
