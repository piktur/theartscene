module Spree
  class CustomPreferences < Spree::Preferences::Configuration
    # Spree::AppConfiguration.class_eval do
    #   preference :domain, :string
    # end

    preference :domain, :string
  end
end
