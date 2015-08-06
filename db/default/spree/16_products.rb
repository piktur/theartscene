# ===========================================================================
# == Define Master Variant attributes

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
    role:         nil, # Spree::Role.find_by!(name: item[:role]) && Spree::Role.find_by!(name: 'admin'),
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
          role:         nil # Spree::Role.find_by!(name: item[:role]) && Spree::Role.find_by!(name: 'admin'),
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

# TODO product option values and properties merge works,
# just activate in the appropriate order
# products_option_values_csv = SmarterCSV.process(
#   File.join(Rails.root, 'db', 'default', 'data', '_ProductsOptionValues.csv')
# )
#
# products_property_values_csv = SmarterCSV.process(
#   File.join(Rails.root, 'db', 'default', 'data', '_ProductsPropertyValues.csv')
# )
#
# # http://stackoverflow.com/questions/17409744/how-do-i-merge-two-arrays-of-hashes-based-on-same-hash-key-value
# products_csv.zip(products_option_values_csv).map! do |row1, row2|
#   if row1[:sku] == row2[:sku]
#     row1.merge(row2)
#   end
# end
#
# products_csv.zip(products_property_values_csv).map! do |row1, row2|
#   if row1[:sku] == row2[:sku]
#     row1.merge(row2)
#   end
# end

# TODO create volume prices according to bulk lot.

# ===========================================================================
# == Create Products

# Convert raw data to Hash for processing
products_csv = SmarterCSV.process(
    File.join(Rails.root, 'db', 'default', 'data', '_Products.csv')
)

products = []

products_csv.take(50).each do |item|
  product = Spree::Product.create!(
    {
      name:         [item[:name], rand(10 ** 10)].join,
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
      taxons:        Spree::Taxon.all[1..2]
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
      tax_category: Spree::TaxCategory.find_by!(name: 'Taxable Goods & Services') #,
      # deleted_at: 1.year.from_now
    }
  )

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
    as_retail:      item[:as_price],
    ab_wholesale:   item[:ab_price],
    aas_retail:     item[:aas_price],
    abs_wholesale:  item[:abs_price]
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
