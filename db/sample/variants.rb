Spree::Sample.load_sample("option_values")
Spree::Sample.load_sample("products")

wnaoc_tiwh = Spree::Product.find_by_name!("Winsor & Newton Artists' Oil Colours Titanium White")
wnaoc_wigy = Spree::Product.find_by_name!("Winsor & Newton Artists' Oil Colours Winsor Green (Yellow Shade)")

small       = Spree::OptionValue.where(name: "37").first
medium      = Spree::OptionValue.where(name: "150").first
large       = Spree::OptionValue.where(name: "200").first
extra_large = Spree::OptionValue.where(name: "500").first

variants = [
  {
    :product => wnaoc_tiwh,
    :option_values => [small],
    :sku => "WOTIWH",
    :cost_price => 11.50
  },
  {
    :product => wnaoc_tiwh,
    :option_values => [medium],
    :sku => "WOTIWHM",
    :cost_price => 20
  },
  {
    :product => wnaoc_tiwh,
    :option_values => [large],
    :sku => "WOTIWHL",
    :cost_price => 40
  },
  {
    :product => wnaoc_tiwh,
    :option_values => [extra_large],
    :sku => "WOTIWHX",
    :cost_price => 200
  },
  {
    :product => wnaoc_wigy,
    :option_values => [small],
    :sku => "ROR-00006",
    :cost_price => 13
  },
  {
    :product => wnaoc_wigy,
    :option_values => [medium],
    :sku => "ROR-00007",
    :cost_price => 35
  },
  {
    :product => wnaoc_wigy,
    :option_values => [large],
    :sku => "ROR-00008",
    :cost_price => 100
  },
  {
    :product => wnaoc_wigy,
    :option_values => [extra_large],
    :sku => "ROR-00009",
    :cost_price => 400
  }
]

masters = {
    wnaoc_tiwh => {
    :sku => "WOTIWH",
    :cost_price => 5,
  },
  wnaoc_wigy => {
    :sku => "WOWIGY",
    :cost_price => 5
  }
}

Spree::Variant.create!(variants)

masters.each do |product, variant_attrs|
  product.master.update_attributes!(variant_attrs)
end
