source 'https://rubygems.org'

gem 'rails', '3.2.2'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg', '0.13.1'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '3.2.4'
  gem 'coffee-rails', '3.2.2'
  gem 'uglifier',     '1.2.3'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'			# leave out - not allowed by heroku
end

gem 'jquery-rails', '2.0.0'

group :development do
  gem 'mongrel', '1.2.0.pre2'	# for ruby 1.9.2
  gem 'rspec-rails'
  gem 'guard-rspec'
end

group :test do
#  gem 'rspec-rails', '2.8.1'	# was 2.6.1 in v.1
  gem 'rspec-rails'
  gem 'capybara', '1.1.2'
  gem 'rb-fchange', '0.0.5'
  gem 'rb-notifu', '0.0.4'
  gem 'win32console', '1.3.0'
  gem 'win32-process'
#  gem 'guard-spork'				# guard-spork does not work in Windows!
  gem 'spork', '> 0.9.0.rc9'
end

group :production do
  gem 'mongrel', '1.2.0.pre2'	# for ruby 1.9.2
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
