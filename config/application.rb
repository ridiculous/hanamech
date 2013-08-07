require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module HanaMech
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.

    config.time_zone = 'Hawaii'

    config.autoload_paths += %W(#{config.root}/lib)

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
        domain: 'heroku.com', # the domain your emails will come from
        address: 'smtp.sendgrid.net', # SMTP server used to send emails
        port: '587',
        authentication: :plain,
        user_name: ENV["SENDGRID_USERNAME"],
        password: ENV["SENDGRID_PASSWORD"],
        enable_starttls_auto: true
    }
  end
end
