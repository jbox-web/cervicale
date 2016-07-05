source 'https://rubygems.org'
ruby '2.3.1'

gem 'easy-app',   git: 'https://github.com/jbox-web/easy-app.git'
gem 'easy-crud',  git: 'https://github.com/jbox-web/easy-crud.git'
gem 'easy-dci',   git: 'https://github.com/jbox-web/easy-dci.git'
gem 'actionform', git: 'https://github.com/jbox-web/actionform.git', require: 'action_form'

# Bundler
gem 'bundler', '>= 1.8.4'

# Configuration
gem 'dotenv-rails'
gem 'figaro'

# Authentication
gem 'bcrypt'
gem 'devise'
gem 'devise_invitable'
gem 'request_store'

# Themes
gem 'themes_on_rails'

# Deployment (DeployIt / Heroku)
gem 'rails_12factor', group: :production

# Base for Calendar management
gem 'dav4rack'

# Calendar exports
gem 'icalendar'

# Events are taggable
gem 'acts-as-taggable-on'

# Calendar permissions
gem 'pundit'

group :test, :development do
  gem 'rspec'
  gem 'rspec-rails'

  gem 'shoulda'
  gem 'shoulda-matchers'
  gem 'shoulda-context'

  gem 'factory_girl'
  gem 'factory_girl_rails'
  gem 'database_cleaner'

  gem 'capybara'

  # Code coverage
  gem 'simplecov'
end

group :development do
  gem 'spring'
  gem 'spring-commands-rspec'

  gem 'turbulence'
  gem 'flog'
  gem 'quiet_assets'

  gem 'mina'
  gem 'mina-puma',    require: false
  gem 'mina-sidekiq', require: false
  gem 'mina-scp',     require: false

  gem 'letter_opener_web'

  gem 'brakeman'
  gem 'bullet'
end
