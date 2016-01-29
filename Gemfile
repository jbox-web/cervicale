source 'https://rubygems.org'
ruby '2.3.0'

gem 'easy-app',  git: 'https://github.com/jbox-web/easy-app.git'
gem 'easy-crud', git: 'https://github.com/jbox-web/easy-crud.git'
gem 'easy-dci',  git: 'https://github.com/jbox-web/easy-dci.git'

gem 'simple_navigation_renderers', '~> 1.0.2', git: 'https://github.com/n-rodriguez/simple_navigation_renderers.git', branch: 'metis_menu'

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
gem 'activerecord-session_store'

# Themes
gem 'themes_on_rails'

# Deployment (DeployIt / Heroku)
gem 'rails_12factor', group: :production

# Base for Calendar management
gem 'dav4rack'

# Calendar exports
gem 'icalendar'

# Form objects
gem 'actionform', '~> 0.0.1', git: 'https://github.com/rails/actionform.git', require: 'action_form'

# Events are taggable
gem 'acts-as-taggable-on', '~> 3.4'

# Calendar permissions
gem 'pundit'

group :test, :development do
  gem 'rspec',       '~> 3.3.0'
  gem 'rspec-rails', '~> 3.3.0'

  gem 'shoulda',          '~> 3.5.0'
  gem 'shoulda-matchers', '~> 2.8.0'
  gem 'shoulda-context',  '~> 1.2.1'

  gem 'factory_girl',       '~> 4.5.0'
  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'database_cleaner',   '~> 1.5.0'

  gem 'capybara', '~> 2.5.0'

  # Code coverage
  gem 'simplecov', '~> 0.10.0'
end

group :development do
  gem 'spring',                '~> 1.4.0'
  gem 'spring-commands-rspec', '~> 1.0.4'

  gem 'turbulence',   '~> 1.2.4'
  gem 'flog',         '~> 4.3.0'
  gem 'quiet_assets', '~> 1.1.0'

  gem 'mina',         '~> 0.3.4'
  gem 'mina-puma',    require: false
  gem 'mina-sidekiq', require: false
  gem 'mina-scp',     require: false

  gem 'letter_opener_web', '~> 1.2.0'

  # gem 'brakeman', '~> 2.6.3'
  gem 'bullet',   '~> 4.14.10'
end
