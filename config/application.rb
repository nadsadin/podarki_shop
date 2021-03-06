require_relative 'boot'

require 'rails/all'
require 'i18n/backend/fallbacks'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
Raven.configure do |config|
  config.dsn = 'https://164812e525ed4132af4572ccb1533347:bea7a16297aa4965aa39f5dea420c2e3@sentry.io/1522422'
end
module PodarkiShop
  class Application < Rails::Application

    config.to_prepare do
      # Load application's model / class decorators
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      # Load application's view overrides
      Dir.glob(File.join(File.dirname(__FILE__), "../app/overrides/*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2


    I18n.default_locale = :ru
    config.i18n.fallbacks = true
    # I18n.locale = :ru
    #
    config.time_zone = "Moscow"

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.exceptions_app = self.routes
  end
end
