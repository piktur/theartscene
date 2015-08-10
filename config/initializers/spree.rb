# ===========================================================================
  # Configure Spree Preferences

  # Note: Initializing preferences available within the Admin will overwrite
  #       any changes that were made through the user interface when you restart.
  #       If you would like users to be able to update a setting with the
  #       Admin it should NOT be set here.
  #
  # Note: If a preference is set here it will be stored within the cache &
  #       database upon initialization.
  #       Just removing an entry from this initializer will not make the
  #       preference value go away.
  #       Instead you must either set a new value or remove entry, clear cache,
  #       and remove database entry.

  # Custom Settings
  # In order to initialize a custom setting do:
  # @example config.Spreesetting_name = 'new value'
  # @example config.track_inventory_levels = false
# ===========================================================================


# ===========================================================================
  # Spree

  # SETTINGS DEFINED HERE CANNOT BE OVERIDDEN BY ADMINISTRATORS
  # core/app/models/spree/app_configuration.rb
  # @docs https://guides.spreecommerce.com/developer/preferences.html
# ===========================================================================
Spree.config do |config|
  config.address_requires_state       = true
  config.admin_interface_logo         = 'spree/logo/logo_lo.svg'
  config.admin_products_per_page      = 15
  config.allow_checkout_on_gateway_error = true
  config.allow_guest_checkout         = true
  config.alternative_shipping_phone   = true
  config.always_include_confirm_step  = true
  config.always_put_site_name_in_title = true
  config.auto_capture                 = false
  config.auto_capture_on_dispatch     = true
  config.binary_inventory_cache       = false
  config.check_for_spree_alerts       = true
  config.checkout_zone                = nil
  config.company                      = Spree::Store.current.code =~ /as|aas/ ? false : true
  config.currency                     = 'AUD'
  # Check the relevant ID in spree_countries table
  # sudo -u postgres psql
  # postgres=# \connect theartscene_development
  # postgres=# SELECT * FROM spree_countries;
  # OR perform query, but lets not waste time here
  # Spree::Country.find_by!(iso: 'AU').id
  # See db/default/spree/countries.rb:29
  # config.default_country_id           = 13
  config.dismissed_spree_alerts       = ''
  config.expedited_exchanges          = false
  config.expedited_exchanges_days_window = 7
  config.last_check_for_spree_alerts  = nil
  config.layout                       = "spree/layouts/#{Spree::Store.current.code}/spree_application"
  config.logo                         = "spree/logo/#{Spree::Store.current.code}/logo_lo.svg"
  config.max_level_in_taxons_menu     = 3
  config.orders_per_page              = 15
  config.properties_per_page          = 15
  config.products_per_page            = 15
  config.promotions_per_page          = 15
  config.customer_returns_per_page    = 15
  config.require_master_price         = true
  config.restock_inventory            = false
  config.return_eligibility_number_of_days = 30
  config.send_core_emails             = true
  # TODO spree-multi-domain extension defines searcher class in an initializer
  # Giving it precedence of over configuration specified here. Will define
  # searcher_class in application.rb instead
  # config.searcher_class               = Spree::Search::Elasticsearch
  config.shipping_instructions        = true
  config.show_only_complete_orders_by_default = false
  config.show_variant_full_price      = false
  config.show_products_without_price  = true
  config.show_raw_product_description = false
  config.tax_using_ship_address       = true
  config.track_inventory_levels       = true

  # config.attachment_default_url
  # config.attachment_path
  # config.attachment_styles          = {
  #   mini:     '48x48>',
  #   small:    '100x100>',
  #   product:  '240x240>',
  #   large:    '600x600>'
  # }.to_json
  # config.attachment_default_style
end

# ===========================================================================
# Custom Preferences
# ===========================================================================
require 'spree/custom_preferences'

Theartscene::Config = Spree::CustomPreferences.new

# Seperate the development domain from public domain
dev_domain = Spree::Store.current.url.split(',').select do |url|
  url if url.include?("#{Spree::Store.current.code}.dev")
end.first

public_domain = Spree::Store.current.url.split(',').select do |url|
  url unless url.include?("#{Spree::Store.current.code}.dev")
end.first

if Rails.env.development? || Rails.env.test?
  Theartscene::Config[:domain] = dev_domain
else
  Theartscene::Config[:domain] = public_domain
end

# ===========================================================================
  # Spree::User
# ===========================================================================
# Define a custom User Class as per docs
# https://guides.spreecommerce.com/developer/authentication.html
Spree.user_class = 'Spree::LegacyUser'


# ===========================================================================
  # Spree Auth
# ===========================================================================
Spree::Auth::Config[:confirmable] = false

# Spree::Ability.register_ability(Spree::Roles::Customers::RetailCustomer)
# Spree::Ability.register_ability(Spree::Roles::Customers::WholesaleCustomer)
# Spree::Ability.register_ability(Spree::Roles::Staff::SalesRep)
# Spree::Ability.register_ability(Spree::Roles::Staff::Administrator)
# ===========================================================================


# ===========================================================================
  # Asset CDN
# ===========================================================================
# Configure Static Assets Delivery via CDN
# https://guides.spreecommerce.com/developer/s3_storage.html
# attachment_config = {
#   s3_credentials: {
#     access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
#     secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
#     bucket:            ENV['S3_BUCKET_NAME']
#   },
#
#   storage:        :s3,
#   s3_headers:     { "Cache-Control" => "max-age=31557600" },
#   s3_protocol:    'https',
#   bucket:         ENV['S3_BUCKET_NAME'],
#   url:            ':s3_domain_url',
#
#   styles: {
#       mini:     '48x48>',
#       small:    '100x100>',
#       product:  '240x240>',
#       large:    '600x600>'
#   },
#
#   path:           '/:class/:id/:style/:basename.:extension',
#   default_url:    '/:class/:id/:style/:basename.:extension',
#   default_style:  'product'
# }
#
# attachment_config.each do |key, value|
#   Spree::Image.attachment_definitions[:attachment][key.to_sym] = value
# end


# ===========================================================================
  # Documents Generation
# ===========================================================================
# Readme outdated, proper configuration below
# Spree::PrintInvoice::Config.set(
#     page_layout: :portrait,
#     page_size: 'A4',
# )
# Spree::PrintInvoice::Config.set(logo_path: '/path/to/public/images/company-logo.png')
# Spree::PrintInvoice::Config.set(store_pdf: true)
# Spree::PrintInvoice::Config.set(storage_path: 'documents/invoices')
# # Spree::PrintInvoice::Config.set(next_number: [1|'your current next invoice number'])


# ==> NOT AVAILABLE IN SPREE 3-0-STABLE =====================================
# Tells Paperclip the form of the URL to use for attachments which are
# missing.
# config.attachment_default_url

# Tells Paperclip the path at which to store images.
# config.attachment_path

# A JSON hash of different styles that are supported by attachments.
# @default
# { "mini":"48x48>",
#   "small":"100x100>",
#   "product":"240x240>",
#   "large":"600x600>"
# }
# config.attachment_styles

# A key from the list of styles from Spree::Config[:attachment_styles] that
# is the default style for images.
# @default 'application'
# config.attachment_default_style

# Determines if prices are labelled as including tax or not.
# @default false.
# config.prices_inc_tax

# Determines if shipments should include VAT calculations.
# @default false.
# config.shipment_inc_vat

# Determines if taxon descendants are shown when showing taxons.
# @default true.
# config.show_descendents
# ===========================================================================