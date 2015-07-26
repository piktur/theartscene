module Spree
  class BusinessConfiguration < Spree::Preferences::Configuration
    preference :domain, :string
  end
end

# OR

# Spree::AppConfiguration.class_eval do
#   preference :domain, :string
# end