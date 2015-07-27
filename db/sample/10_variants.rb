wnaoc_tiwh = Spree::Product.find_by!(name: "Winsor & Newton Artists' Oil Colours Titanium White 37mL")
wnaoc_tiwhm = Spree::Product.find_by!(name: "Winsor & Newton Artists' Oil Colours Titanium White 120mL")
wnaoc_wigy = Spree::Product.find_by!(name: "Winsor & Newton Artists' Oil Colours Winsor Green (Yellow Shade) 37mL")
wnaoc_wigym = Spree::Product.find_by!(name: "Winsor & Newton Artists' Oil Colours Winsor Green (Yellow Shade) 120mL")
msa_jb = Spree::Product.find_by!(name: "Josef Zbukvic Workshop at The Mitchell School of Art Summer 2016")
msa_hp = Spree::Product.find_by!(name: "Herman Pekel Workshop at The Mitchell School of Art Summer 2016")

# small       = Spree::OptionValue.where(name: "37").first
# medium      = Spree::OptionValue.where(name: "150").first
# large       = Spree::OptionValue.where(name: "200").first
# extra_large = Spree::OptionValue.where(name: "500").first

accom = Spree::OptionValue.where(name: "Accommodation").first

# variants = [
#   {
#     :product => msa_jb,
#     :option_values => [accom],
#     :sku => "MSAJBA",
#     :cost_price => 1450
#   },
#   {
#     :product => msa_hp,
#     :option_values => [accom],
#     :sku => "MSAHPA",
#     :cost_price => 1450
#   },
  # {
  #   :product => wnaoc_tiwh,
  #   :option_values => [large],
  #   :sku => "WOTIWHL",
  #   :cost_price => 40
  # },
  # {
  #   :product => wnaoc_tiwh,
  #   :option_values => [extra_large],
  #   :sku => "WOTIWHX",
  #   :cost_price => 200
  # },
  # {
  #   :product => wnaoc_wigy,
  #   :option_values => [small],
  #   :sku => "WOWIGYS",
  #   :cost_price => 13
  # },
  # {
  #   :product => wnaoc_wigy,
  #   :option_values => [medium],
  #   :sku => "WOWIGYM",
  #   :cost_price => 35
  # },
  # {
  #   :product => wnaoc_wigy,
  #   :option_values => [large],
  #   :sku => "WOWIGYL",
  #   :cost_price => 100
  # },
  # {
  #   :product => wnaoc_wigy,
  #   :option_values => [extra_large],
  #   :sku => "WOWIGYX",
  #   :cost_price => 400
  # }
# ]

masters = {
  wnaoc_tiwh => {
      :option_values => [accom],
      :sku => "WOTIWH",
      :cost_price => 12.40
  },
  wnaoc_tiwhm => {
      :option_values => [accom],
      :sku => "WOTIWHM",
      :cost_price => 5
  },
  wnaoc_wigy => {
      :option_values => [accom],
      :sku => "WOWIGY",
      :cost_price => 5
  },
  wnaoc_wigym => {
      :option_values => [accom],
      :sku => "WOWIGYM",
      :cost_price => 5
  },
  msa_jb => {
    :option_values => [accom],
    :sku => "MSAJBA",
    :cost_price => 1450
  },

  msa_hp => {
    :option_values => [accom],
    :sku => "MSAHPA",
    :cost_price => 1450
  }
}

# Spree::Variant.create!(variants)

masters.each do |product, variant_attrs|
  product.master.update_attributes!(variant_attrs)
end


Spree::PriceBook.create!(
   {
       name: 'Recommended Retail',
       currency: Spree::Config.currency,
       active_from: 1.month.ago,
       active_to: 1.year.from_now,
       default: false,
       parent: Spree::PriceBook.find_or_create_by!(name: 'Default'),
       price_adjustment_factor: 1,
       priority: 1,
       discount: true,
       role_id: 1
   }
)

Spree::Product.find_each do |product|
  pb = Spree::PriceBook.find_by!(name: 'Recommended Retail')
  pb.add_product(product)
end

Spree::PriceBook.create!({
   name: 'Retail',
   currency: Spree::Config.currency,
   active_from: 1.month.ago,
   active_to: 1.year.from_now,
   default: false,
   parent: Spree::PriceBook.find_or_create_by!(name: 'Default'),
   price_adjustment_factor: 0.9,
   priority: 1,
   discount: true,
   role_id: 1
})

Spree::PriceBook.create!({
   name: 'School',
   currency: Spree::Config.currency,
   active_from: 1.month.ago,
   active_to: 1.year.from_now,
   default: false,
   parent: Spree::PriceBook.find_or_create_by!(name: 'Default'),
   price_adjustment_factor: 0.8,
   priority: 1,
   discount: true,
   role_id: [1, 2]
})

Spree::PriceBook.create!({
   name: 'Wholesale',
   currency: Spree::Config.currency,
   active_from: 1.month.ago,
   active_to: 1.year.from_now,
   default: false,
   parent: Spree::PriceBook.find_or_create_by!(name: 'Default'),
   price_adjustment_factor: 0.6,
   priority: 1,
   discount: true,
   role_id: [1, 2]
})

Spree::PriceBook.create!({
   name: 'Retail Winter Sale 15',
   currency: Spree::Config.currency,
   active_from: 1.month.ago,
   active_to: 1.week.from_now,
   default: false,
   parent: Spree::PriceBook.find_or_create_by!(name: 'Default'),
   price_adjustment_factor: 0.75,
   priority: 1,
   discount: true,
   role_id: [1, 2]
})

Spree::PriceBook.create!({
   name: 'Retail Loyal',
   currency: Spree::Config.currency,
   active_from: 1.month.ago,
   active_to: 1.year.from_now,
   default: false,
   parent: Spree::PriceBook.find_or_create_by!(name: 'Default'),
   price_adjustment_factor: 0.85,
   priority: 1,
   discount: true,
   role_id: 1
})

Spree::StorePriceBook.create!([
  {
      price_book: Spree::PriceBook.find_or_create_by!(name: 'Retail'),
      store: Spree::Store.find_by!(code: 'as'),
      #active: true,
      #priority: 1
  },

  {
      price_book: Spree::PriceBook.find_or_create_by!(name: 'Recommended Retail'),
      store: Spree::Store.find_by!(code: 'aas'),
      #active: true,
      #priority: 1
  },

  {
      price_book: Spree::PriceBook.find_or_create_by!(name: 'Wholesale'),
      store: Spree::Store.find_by!(code: 'ab'),
      #active: true,
      #priority: 1
  },

  {
      price_book: Spree::PriceBook.find_or_create_by!(name: 'Retail Winter Sale 15'),
      store: Spree::Store.find_by!(code: 'as'),
      #active: true,
      #priority: 1
  }
])