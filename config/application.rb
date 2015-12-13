require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Cervicale
  class Application < Rails::Application

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/lib)

    # ActiveRecord config
    config.active_record.store_full_sti_class = true
    config.active_record.raise_in_transactional_callbacks = true

    # Locales
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.yml').to_s]
    config.i18n.default_locale = :fr
    config.i18n.available_locales = [:en, :fr]

    # Timezone
    config.time_zone = 'Paris'

    # Generators
    config.generators do |g|
      g.orm :active_record
    end

    # ActiveJob config
    config.active_job.queue_adapter = :sidekiq
  end
end
