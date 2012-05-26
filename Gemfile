source :rubygems

gem 'activerecord', '3.1.3'
gem 'activesupport', '3.1.3'
gem 'awesome_print'
gem 'chronic', '0.6.6'
gem 'fandango', '0.2.1'
# Waiting for newer version that includes fix for raising LimitExceeded Error.
# https://github.com/alexreisner/geocoder/issues/187.
gem 'geocoder', '1.1.0', path: 'vendor/gems/geocoder-1.1.0'
gem 'httparty', '0.8.1'
gem 'mechanize', '2.1'
gem 'pony', '1.4'
gem 'retryable', '1.2.5'
gem 'scopes_for_associations', '0.1.5'
gem 'twitter', '2.0.2'

group :production do
  gem 'pg'
end

group :development do
  gem 'git_remote_branch'
end

group :test do
  gem 'database_cleaner', '0.7.1'
  gem 'factory_girl', '2.4.0'
  gem 'fakeweb', '1.3.0'
  gem 'minitest', '2.10.0'
  gem 'mocha', '0.10.2', require: false
  gem 'timecop', '0.3.5'
  gem 'vcr', '1.11.3'
end

group :development, :test do
  gem 'sqlite3', '1.3.5'
end
