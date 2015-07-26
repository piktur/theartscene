# ===========================================================================
# Application Preferences
# ===========================================================================
require 'spree/business_configuration'

Theartscene::Config = Spree::BusinessConfiguration.new

Theartscene::Config[:domain] =
    if Rails.env.development? || Rails.env.test?
      "#{Spree::Store.current.code}.dev"
    else
      Spree::Store.current.url
    end