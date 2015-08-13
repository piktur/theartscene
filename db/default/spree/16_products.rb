def populate_properties(product, data={})
  data.each {|prop, val| product.set_property(prop, val)} if data.present?
end

# ===========================================================================
# = Create Inventory from CSV

# ===========================================================================
# == Pre-populate Currency Conversion rates

# Execute rake task to populate currency rates
# require 'rake'
# Rake::Task['spree:price_books:currency_rates'].invoke
#
# set the seconds after than the current rates are automatically expired
# by default, they never expire
Money::Bank::GoogleCurrency.ttl_in_seconds = 86400
# set default bank to instance of GoogleCurrency
Money.default_bank = Money::Bank::GoogleCurrency.new
Money::Currency.all.each do |currency|
  # Limit to only major currencies, which have priority below 100.
  next if currency.priority >= 100
  begin
    rate = Money.default_bank.get_rate(Spree::CurrencyRate.default.currency, currency.iso_code)
    if cr = Spree::CurrencyRate.find_or_create_by(
        base_currency: Spree::CurrencyRate.default.currency,
        currency: currency.iso_code,
        default: (Spree::Config[:currency] == currency.iso_code)
      )
      cr.update_attribute :exchange_rate, rate
    end
  rescue Money::Bank::UnknownRate # Google doesn't track this currency.
  rescue Money::Bank::GoogleCurrencyFetchError => ex
    puts currency.inspect
    puts ex.message
    puts ex.backtrace
  end
end

# ===========================================================================
# == Create PriceBooks

# Convert raw data to Hash for processing
price_books_csv = SmarterCSV.process(
    File.join(Rails.root, 'db', 'default', 'data', '_PriceBooks.csv')
)

price_books_csv.each do |item|
  # Seems as though PriceBook can apply to only one role
  # roles   = []
  #
  # if item[:roles]
  #   if item[:roles].include?(',')
  #     item[:roles].gsub(' ', '').split(',').each do |role|
  #       roles << Spree::Role.find_or_create_by!(name: role)
  #     end
  #   else
  #     roles << Spree::Role.find_by!(name: item[:roles])
  #   end
  # end

  price_book = Spree::PriceBook.create!(
    name:         item[:name],
    currency:     item[:currency] || Spree::Config.currency,
    active_from:  (1.day.ago).strftime('%Y/%m/%d'), # Time.parse(item[:active_from].to_s) || 1.day.ago,
    active_to:    (1.year.from_now).strftime('%Y/%m/%d'), # Time.parse(item[:active_to].to_s) || 1.year.from_now,
    default:      item[:default] == 1 ? true : false, # item[:default] == 1 ? true : false,
    price_adjustment_factor: item[:price_adjustment_factor] || nil, # item[:price_adjustment_factor] || 1,
    priority:     item[:priority] || 0,
    discount:     item[:discount] == 1 ? true : false, # item[:discount] == 1 ? true : false,
    role:         Spree::Role.find_by!(name: item[:role]), # Spree::Role.find_by!(name: item[:role]) && Spree::Role.find_by!(name: 'admin'),
    parent:
      if item[:parent]
        Spree::PriceBook.find_or_create_by!(
          name:         item[:parent],
          currency:     item[:currency] || Spree::Config.currency,
          active_from:  (1.day.ago).strftime('%Y/%m/%d'), # Time.parse(item[:active_from].to_s) || 1.day.ago,
          active_to:    (1.year.from_now).strftime('%Y/%m/%d'), # Time.parse(item[:active_to].to_s) || 1.year.from_now,
          default:      false, # item[:discount] == 1 ? true : false, # item[:default] == 1 ? true : false,
          price_adjustment_factor: nil || item[:price_adjustment_factor],
          priority:     item[:priority] || 0,
          discount:     false, # item[:discount] == 1 ? true : false, # item[:discount] == 1 ? true : false,
          # Price Books mightn't require role scope since they are scoped to a store. However, if it is required
          # how can we permit multiple roles?
          role:         Spree::Role.find_by!(name: item[:role]) # Spree::Role.find_by!(name: item[:role]) && Spree::Role.find_by!(name: 'admin'),
        )
      end
  )

  if item[:stores]
    if item[:stores].include?(',')
      item[:stores].gsub(' ', '').split(',').each do |store|
        Spree::StorePriceBook.create!(
          price_book: price_book,
          store: Spree::Store.find_by!(code: store),
          priority: item[:priority]
        )
      end
    else
      Spree::StorePriceBook.create!(
        price_book: price_book,
        store: Spree::Store.find_by!(code: item[:stores]),
        priority: item[:priority]
      )
    end
  end
end


# ===========================================================================
# == Create Products

# TODO create volume prices according to bulk lot.

# Convert raw data to Hash for processing
products_csv = SmarterCSV.process(
    File.join(Rails.root, 'db', 'default', 'data', '_Products.csv')
)

# products_option_values_csv = SmarterCSV.process(
#     File.join(Rails.root, 'db', 'default', 'data', '_ProductsOptionValues.csv')
# )
#
# products_property_values_csv = SmarterCSV.process(
#     File.join(Rails.root, 'db', 'default', 'data', '_ProductsPropertyValues.csv')
# )
#
# # http://stackoverflow.com/questions/17409744/how-do-i-merge-two-arrays-of-hashes-based-on-same-hash-key-value
# products_csv.zip(products_option_values_csv).map! do |product_data, option_values|
#   if product_data[:sku] == option_values[:sku]
#     product_data.merge(option_values: option_values)
#   end
# end
#
# products_csv.zip(products_property_values_csv).map! do |product_data, properties|
#   if product_data[:sku] == properties[:sku]
#     product_data.merge(property_values: properties)
#   end
# end

products = []

products_csv.take(300).each do |item|
  product = Spree::Product.create!(
    {
      # Name must be unique
      # [item[:accounting_name].titleize, rand(10 ** 10)].join,
      name:         item[:accounting_name].titleize,
      tax_category: Spree::TaxCategory.find_by!(name: 'Taxable Goods & Services'),
      shipping_category: Spree::ShippingCategory.find_by!(
      name: item[:shipping_category] || 'default'),
      price:        item[:rrp] || item[:as_price] || 0,
      description:  item[:description],
      # TODO until we fix the slug in excel doc
      slug:         [item[:name].parameterize, rand(10 ** 10)].join('-'), # item[:slug],
      available_on: Time.zone.now, # item[:available_on],
      # Deleted_at must be null
      deleted_at:   nil, #1.year.from_now, #item[:deleted_at] ? Time.parse(item[:deleted_at].to_s) : 1.year.from_now,
      meta_description: item[:meta_description] || 'An artist will do with',
      meta_keywords: 'art supplies', # item[:meta_keywords],
      promotionable: true, # item[:promotionable]
      # TODO properly align Taxons with and products, for now, just test a random selection
      taxons:        Spree::Taxon.all[1..2],
      prototype_id:  nil # Spree::Prototype.find_by(name: item[:prototype]) || nil
    }
  )

  product.save!

# ===========================================================================
# == Define Master Variant attributes

  product.master.update_attributes!(
    {
      sku:        item[:sku],
      weight:     item[:weight] != nil ? item[:weight] : 1,
      height:     item[:length] != nil ? item[:length] : 1,
      width:      item[:width] != nil ? item[:width] : 1,
      depth:      item[:depth] != nil ? item[:depth] : 1,
      cost_price: item[:cost_price] != nil ? item[:cost_price] : 10,
      cost_currency: item[:cost_currency] || Spree::Config.currency,
      track_inventory: item[:track_inventory],
      # Ensure numeric value
      stock_items_count: item[:count] != nil ? item[:count].to_i : 10,
      tax_category: Spree::TaxCategory.find_by!(name: 'Taxable Goods & Services')
      # deleted_at: 1.year.from_now
    }
  )

  # if product[:prototype_id]
  #   # If prototype defined build the options and properties associations
  #   product.add_associations_from_prototype
  #
  #   # Populate option values
  #   if item[:option_values]
  #     item[:option_values].each do |option_type, option_value|
  #       product.option_values << Spree::OptionValue.find_or_create_by!(
  #         name: option_value,
  #         presentation: option_value
  #       )
  #     end
  #   end
  #
  #   populate_properties(product, item[:property_values])
  #
  # # Otherwise build associations according to available data
  # else
  #   # Populate option values
  #   if item[:option_values]
  #     item[:option_values].each do |option_type, option_value|
  #       product.option_types << Spree::OptionType.find_by!(name: option_type)
  #
  #       product.option_values << Spree::OptionValue.find_or_create_by!(
  #           name: option_value,
  #           presentation: option_value
  #       )
  #     end
  #   end
  #
  #   populate_properties(product, item[:property_values])
  # end

# ===========================================================================
# == Create Variants
  # product.variants

# ===========================================================================
# == Attach Images

  def image(name, type='jpg')
    path = File.join(File.dirname(__FILE__), 'images', "#{name}.#{type}")
    File.exist?(path) ? File.open(path) : nil
  end

  variant_images = {product.master => []}

  if item[:primary_image]
    # TODO we need to get some proper image assets
    # primary = {attachment: image(item[:primary_image] || 'wnaoc_tiwh')}
    # until then
    variant_images[product.master] << {attachment: image('wnaoc_wigy')}
  else
    variant_images[product.master] << {attachment: image('wnaoc_wigy')}
  end

  if item[:secondary_images]
    item[:secondary_images].split(',').each do |asset|
      # TODO again we need to get some proper image assets
      # secondary = {attachment: image(asset || 'wnaoc_wigy')}
      # until then
      variant_images[product.master] << {attachment: image('wnaoc_wigy_swatch')}
    end
  else
    variant_images[product.master] << {attachment: image('wnaoc_wigy_swatch')}
  end

  variant_images[product.master].each do |attr|
    product.master.images.create!(attr) if attr[:attachment]
  end

  product.save!

# ===========================================================================
# == Add to relevant stores' inventory
  product.stores = []

  if item[:stores]
    if item[:stores].include?(',')
      item[:stores].gsub(' ', '').split(',').each do |store|
        product.stores << Spree::Store.find_by!(code: store)
      end
    else
      product.stores << Spree::Store.find_by!(code: item[:stores])
    end
  end

  product.save!


  products << product

# ===========================================================================
# == Set 'explicit' Store Price per Product
# Dependent PriceBook ie. sale price_books calculate prices according to set
# discount percentage

  # Pair StorePriceBooks and relevant Price
  explicit_price_per_store = {
    as_retail:      item[:as_price] || 10,
    ab_wholesale:   item[:ab_price] || 10,
    aas_retail:     item[:aas_price] || 10,
    abs_wholesale:  item[:abs_price] || 10
  }

  # Then create the Price and append it to the appropriate PriceBook
  explicit_price_per_store.each do |store, price|
    price_book = Spree::PriceBook.find_by!(name: store)
    # Reject product if price invalid
    # TODO validate prices, ab_price should never be greater than
    # as_price etc.

    # TODO apply similar test to StoreProducts
    if price.present?
      price_book.prices << Spree::Price.create!(
        variant_id: product.master.id,
        price_book_id: price_book,
        amount: price,
        currency: item[:currency]
      )
      price_book.save!
    end
  end
end

# ===========================================================================
# == Set 'explicit' Store Price for Existing Products
# For Spree demo data only
# price_book = Spree::PriceBook.find_by!(default: true)
#
# Spree::Product.all.each do |product|
#   price_book.prices << Spree::Price.find_or_create_by!(
#       variant_id: product.master.id,
#       price_book_id: price_book,
#       amount: product.master.price,
#       currency: product.cost_currency
#   )
#   price_book.save!
#
#   product.stores << Spree::Store.find_by!(default: true)
#   # product.save!
# end

# ===========================================================================
# == define Default Attributes
# TODO in case important values invalid or aren't present in the csv

# default_attrs = {
#     available_on: Time.zone.now
#     deleted_at:
# }
# products.each do |product_attrs|
#   product = Spree::Product.create!(default_attrs.merge(product_attrs))
#   product.save!
# end


# ===========================================================================
# == Demo Services

# services = [
#   {
#       :name => "Josef Zbukvic Workshop at The Mitchell School of Art Summer 2016",
#       :tax_category => services,
#       :shipping_category => service,
#       :price => 750
#   },
#   {
#       :name => "Herman Pekel Workshop at The Mitchell School of Art Summer 2016",
#       :tax_category => services,
#       :shipping_category => service,
#       :price => 750
#   }
# ]

# services.each do |product_attrs|
#   product = Spree::Product.create!(product_attrs)
#   product.save!
# end

# ===========================================================================
# == Demo Option Types
# # volume = Spree::OptionType.find_by!(name: "Volume")
# extras = Spree::OptionType.find_by!(name: "Extras")
# #
# # wnaoc_tiwh = Spree::Product.find_by!(name: "Winsor & Newton Artists' Oil Colours Titanium White 37mL")
# # wnaoc_tiwh.option_types = [volume]
# # wnaoc_tiwh.save!
# #
# # wnaoc_wigy = Spree::Product.find_by!(name: "Winsor & Newton Artists' Oil Colours Winsor Green (Yellow Shade) 37mL")
# # wnaoc_wigy.option_types = [volume]
# # wnaoc_wigy.save!
#
# msa_jz = Spree::Product.find_by!(name: "Josef Zbukvic Workshop at The Mitchell School of Art Summer 2016")
# msa_jz.option_types = [extras]
# msa_jz.save!
#
# msa_hp = Spree::Product.find_by!(name: "Herman Pekel Workshop at The Mitchell School of Art Summer 2016")
# msa_hp.option_types = [extras]
# msa_hp.save!

# ===========================================================================
# == Demo Properties

# products = {
#     "Winsor & Newton Artists' Oil Colours Titanium White 37mL" =>
#         {
#             "Manufacturer" => "Winsor & Newton",
#             "Brand" => "Artists' Oil Colours",
#             "Manufacter Code" => "50730735",
#             "Colour" => "Titanium White",
#             "Description" => "Titanium White is a clean white pigment. It is the most opaque white pigment and is considered a standard strong white colour.",
#             "Pigments" => "PW6, PW4"
#         },
#
#     "Winsor & Newton Artists' Oil Colours Titanium White 120mL" =>
#         {
#             "Manufacturer" => "Winsor & Newton",
#             "Brand" => "Artists' Oil Colours",
#             "Manufacter Code" => "50730735",
#             "Colour" => "Titanium White",
#             "Description" => "Titanium White is a clean white pigment. It is the most opaque white pigment and is considered a standard strong white colour.",
#             "Pigments" => "PW6, PW4"
#         },
#
#     "Winsor & Newton Artists' Oil Colours Winsor Green (Yellow Shade) 37mL" =>
#         {
#             "Manufacturer" => "Winsor & Newton",
#             "Brand" => "Artists' Oil Colours",
#             "Manufacter Code" => "50904839",
#             "Colour" => "Winsor Green (Yellow Shade)",
#             "Description" => "Winsor Green (Yellow Shade) is a brilliant transparent green pigment with a yellow undertone. It is made from the modern pigment Phthalocyanine which was introduced in 1930s.",
#             "Pigments" => "PG36"
#         },
#
#     "Winsor & Newton Artists' Oil Colours Winsor Green (Yellow Shade) 120mL" =>
#         {
#             "Manufacturer" => "Winsor & Newton",
#             "Brand" => "Artists' Oil Colours",
#             "Manufacter Code" => "50904839",
#             "Colour" => "Winsor Green (Yellow Shade)",
#             "Description" => "Winsor Green (Yellow Shade) is a brilliant transparent green pigment with a yellow undertone. It is made from the modern pigment Phthalocyanine which was introduced in 1930s.",
#             "Pigments" => "PG36"
#         },
#
#     "Josef Zbukvic Workshop at The Mitchell School of Art Summer 2016" =>
#         {
#             "Date" => "18-24 January 2016",
#             "Tutor" => "Josef Zbukvic",
#             "Title" => "Watercolour Godhood",
#             "Location" => "Charles Sturt University Campus",
#             "Skill Level" => "Advanced"
#         },
#     "Herman Pekel Workshop at The Mitchell School of Art Summer 2016" =>
#         {
#             "Date" => "18-24 January 2016",
#             "Tutor" => "Herman Pekel",
#             "Title" => "Masterful Oil Slick",
#             "Location" => "Charles Sturt University Campus",
#             "Skill Level" => "Advanced"
#         }
# }
#
# products.each do |name, properties|
#   product = Spree::Product.find_by_name(name)
#   properties.each do |prop_name, prop_value|
#     product.set_property(prop_name, prop_value)
#   end
# end

# ===========================================================================
# == Demo PriceBooks
# # Convert raw data to Hash for processing
# csv = SmarterCSV.process(
#     File.join(Rails.root, 'db', 'default', 'data', '_PriceBooks.csv')
# )
#
# csv.each do |item|
#   roles = []
#   stores = []
#
#   if item[:roles]
#     if item[:roles].include?(',')
#       item[:roles].gsub(' ', '').split(',').each do |role|
#         roles << Spree::Role.find_or_create_by!(name: role)
#       end
#     else
#       Spree::Role.find_by!(name: item[:roles])
#     end
#   end
#
#   if item[:stores]
#     if item[:stores].include?(',')
#       item[:stores].gsub(' ', '').split(',').each do |store|
#         stores << Spree::Store.find_by!(code: store)
#       end
#     else
#       Spree::Store.find_by!(code: item[:stores])
#     end
#   end
#
#   Spree::PriceBook.create!(
#     name:         item[:name],
#     currency:     item[:currency] || Spree::Config.currency,
#     active_from:  item[:active_from] || 1.day.ago,
#     active_to:    item[:active_to] || 1.year.from_now,
#     default:      item[:default] == 1 ? true : false,
#     parent:       Spree::PriceBook.find_or_create_by!(name: item[:parent], \
#                     currency: Spree::Config.currency,
#                     price_adjustment_factor: 0) ||
#                   Spree::PriceBook.find_or_create_by!(name: 'Default', \
#                     currency: Spree::Config.currency,
#                     price_adjustment_factor: 0),
#     price_adjustment_factor: item[:price_adjustment_factor] || 0,
#     priority:     item[:priority] || 0,
#     discount:     item[:discount] == 1 ? true : false,
#     role_id:      [roles],
#     store_id:     [stores]
#   )
# end
#
# Spree::Product.find_each do |product|
#   pb = Spree::PriceBook.find_by!(name: 'Recommended Retail')
#   pb.add_product(product)
# end

# ===========================================================================
# == Demo Variants
# wnaoc_tiwh = Spree::Product.find_by!(name: "Winsor & Newton Artists' Oil Colours Titanium White 37mL")
# wnaoc_tiwhm = Spree::Product.find_by!(name: "Winsor & Newton Artists' Oil Colours Titanium White 120mL")
# wnaoc_wigy = Spree::Product.find_by!(name: "Winsor & Newton Artists' Oil Colours Winsor Green (Yellow Shade) 37mL")
# wnaoc_wigym = Spree::Product.find_by!(name: "Winsor & Newton Artists' Oil Colours Winsor Green (Yellow Shade) 120mL")
# msa_jb = Spree::Product.find_by!(name: "Josef Zbukvic Workshop at The Mitchell School of Art Summer 2016")
# msa_hp = Spree::Product.find_by!(name: "Herman Pekel Workshop at The Mitchell School of Art Summer 2016")
#
# # small       = Spree::OptionValue.where(name: "37").first
# # medium      = Spree::OptionValue.where(name: "150").first
# # large       = Spree::OptionValue.where(name: "200").first
# # extra_large = Spree::OptionValue.where(name: "500").first
#
# accom = Spree::OptionValue.where(name: "Accommodation").first
#
# # variants = [
# #   {
# #     :product => msa_jb,
# #     :option_values => [accom],
# #     :sku => "MSAJBA",
# #     :cost_price => 1450
# #   },
# #   {
# #     :product => msa_hp,
# #     :option_values => [accom],
# #     :sku => "MSAHPA",
# #     :cost_price => 1450
# #   },
# # {
# #   :product => wnaoc_tiwh,
# #   :option_values => [large],
# #   :sku => "WOTIWHL",
# #   :cost_price => 40
# # },
# # {
# #   :product => wnaoc_tiwh,
# #   :option_values => [extra_large],
# #   :sku => "WOTIWHX",
# #   :cost_price => 200
# # },
# # {
# #   :product => wnaoc_wigy,
# #   :option_values => [small],
# #   :sku => "WOWIGYS",
# #   :cost_price => 13
# # },
# # {
# #   :product => wnaoc_wigy,
# #   :option_values => [medium],
# #   :sku => "WOWIGYM",
# #   :cost_price => 35
# # },
# # {
# #   :product => wnaoc_wigy,
# #   :option_values => [large],
# #   :sku => "WOWIGYL",
# #   :cost_price => 100
# # },
# # {
# #   :product => wnaoc_wigy,
# #   :option_values => [extra_large],
# #   :sku => "WOWIGYX",
# #   :cost_price => 400
# # }
# # ]
#
# masters = {
#     wnaoc_tiwh => {
#         :option_values => [accom],
#         :sku => "WOTIWH",
#         :cost_price => 12.40
#     },
#     wnaoc_tiwhm => {
#         :option_values => [accom],
#         :sku => "WOTIWHM",
#         :cost_price => 5
#     },
#     wnaoc_wigy => {
#         :option_values => [accom],
#         :sku => "WOWIGY",
#         :cost_price => 5
#     },
#     wnaoc_wigym => {
#         :option_values => [accom],
#         :sku => "WOWIGYM",
#         :cost_price => 5
#     },
#     msa_jb => {
#         :option_values => [accom],
#         :sku => "MSAJBA",
#         :cost_price => 1450
#     },
#
#     msa_hp => {
#         :option_values => [accom],
#         :sku => "MSAHPA",
#         :cost_price => 1450
#     }
# }
#
# # Spree::Variant.create!(variants)
#
# masters.each do |product, variant_attrs|
#   product.master.update_attributes!(variant_attrs)
# end
#
#
# Spree::PriceBook.create!(
#   {
#     name: 'Recommended Retail',
#     currency: Spree::Config.currency,
#     active_from: 1.month.ago,
#     active_to: 1.year.from_now,
#     default: false,
#     parent: Spree::PriceBook.find_or_create_by!(name: 'Default'),
#     price_adjustment_factor: 1,
#     priority: 1,
#     discount: true,
#     role_id: 1
#   }
# )
#
# Spree::Product.find_each do |product|
#   pb = Spree::PriceBook.find_by!(name: 'Recommended Retail')
#   pb.add_product(product)
# end
#
# Spree::PriceBook.create!({
#   name: 'Retail',
#   currency: Spree::Config.currency,
#   active_from: 1.month.ago,
#   active_to: 1.year.from_now,
#   default: false,
#   parent: Spree::PriceBook.find_or_create_by!(name: 'Default'),
#   price_adjustment_factor: 0.9,
#   priority: 1,
#   discount: true,
#   role_id: 1
# })
#
# Spree::PriceBook.create!({
#   name: 'School',
#   currency: Spree::Config.currency,
#   active_from: 1.month.ago,
#   active_to: 1.year.from_now,
#   default: false,
#   parent: Spree::PriceBook.find_or_create_by!(name: 'Default'),
#   price_adjustment_factor: 0.8,
#   priority: 1,
#   discount: true,
#   role_id: [1, 2]
# })
#
# Spree::PriceBook.create!({
#   name: 'Wholesale',
#   currency: Spree::Config.currency,
#   active_from: 1.month.ago,
#   active_to: 1.year.from_now,
#   default: false,
#   parent: Spree::PriceBook.find_or_create_by!(name: 'Default'),
#   price_adjustment_factor: 0.6,
#   priority: 1,
#   discount: true,
#   role_id: [1, 2]
# })
#
# Spree::PriceBook.create!({
#   name: 'Retail Winter Sale 15',
#   currency: Spree::Config.currency,
#   active_from: 1.month.ago,
#   active_to: 1.week.from_now,
#   default: false,
#   parent: Spree::PriceBook.find_or_create_by!(name: 'Default'),
#   price_adjustment_factor: 0.75,
#   priority: 1,
#   discount: true,
#   role_id: [1, 2]
# })
#
# Spree::PriceBook.create!({
#   name: 'Retail Loyal',
#   currency: Spree::Config.currency,
#   active_from: 1.month.ago,
#   active_to: 1.year.from_now,
#   default: false,
#   parent: Spree::PriceBook.find_or_create_by!(name: 'Default'),
#   price_adjustment_factor: 0.85,
#   priority: 1,
#   discount: true,
#   role_id: 1
# })
#
# Spree::StorePriceBook.create!([
#   {
#       price_book: Spree::PriceBook.find_or_create_by!(name: 'Retail'),
#       store: Spree::Store.find_by!(code: 'as'),
#       #active: true,
#       #priority: 1
#   },
#
#   {
#       price_book: Spree::PriceBook.find_or_create_by!(name: 'Recommended Retail'),
#       store: Spree::Store.find_by!(code: 'aas'),
#       #active: true,
#       #priority: 1
#   },
#
#   {
#       price_book: Spree::PriceBook.find_or_create_by!(name: 'Wholesale'),
#       store: Spree::Store.find_by!(code: 'ab'),
#       #active: true,
#       #priority: 1
#   },
#
#   {
#       price_book: Spree::PriceBook.find_or_create_by!(name: 'Retail Winter Sale 15'),
#       store: Spree::Store.find_by!(code: 'as'),
#       #active: true,
#       #priority: 1
#   }
# ])
