# After generating bundle install don't forget to follow the following steps before checkin
# - Remove -x86-mingw32 by empty string
# - Change the PLATFORMS to be ruby

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.1'

# Use Puma as the app server
gem 'puma', '~> 3.0'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

gem 'jwt'

gem 'httpclient'

gem 'responders', '~> 2.0'

gem 'active_model_serializers', '~> 0.8.2'

gem 'bcrypt', '~> 3.1.7'

# Environment variables
gem 'figaro'

# Documentation
gem 'swagger-blocks'

# Upload images (avatar)
gem 'carrierwave'
gem 'mini_magick'

# Cloud storage
gem "fog-dropbox", :git => 'https://github.com/fog/fog-dropbox.git'

gem 'orm_adapter'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri

  gem 'sqlite3'
end

group :test do
  gem "webrat", "0.7.3", require: false
  gem "mocha", "~> 1.1", require: false
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :production do
  # Use sqlite3 as the database for Active Record
  gem 'pg'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
