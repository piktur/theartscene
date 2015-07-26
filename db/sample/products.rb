Spree::Sample.load_sample("tax_categories")
Spree::Sample.load_sample("shipping_categories")

goods = Spree::TaxCategory.find_by_name!("Goods")
shipping_category = Spree::ShippingCategory.find_by_name!("Default")

default_attrs = {
  :description => "We use only the purest pigments with the most suitable drying oils. Each colour is individually formulated to optimise and enhance the pigments’ natural characteristics to provide covering power, tinting strength and stability.

Pigments: With 80 single pigment colours, this range offers infinite colour possibilities and brighter secondary mixes.

Consistency & Texture: The buttery, stiff consistency of Artists’ Oil Colour is ideal for retaining brush or palette knife strokes and can be thinned to a very fine glaze.

Surface Sheen: The sheen reflects the pigments used and the different levels of oil in each formulation, so the gloss level varies across individual colours. This can be controlled through the selection of surface, the addition of solvent and the mediums used.",
  :available_on => Time.zone.now
}

products = [
  {
    :name => "Winsor & Newton Artists' Oil Colours Titanium White",
    :tax_category => goods,
    :shipping_category => shipping_category,
    :price => 12.40
  },
  {
    :name => "Winsor & Newton Artists' Oil Colours Winsor Green (Yellow Shade)",
    :tax_category => goods,
    :shipping_category => shipping_category,
    :price => 15.60
  }
]

products.each do |product_attrs|
  default_shipping_category = Spree::ShippingCategory.find_by_name!("Default")
  product = Spree::Product.create!(default_attrs.merge(product_attrs))
  product.shipping_category = default_shipping_category
  product.save!
end

Spree::Config[:currency] = "AUD"
