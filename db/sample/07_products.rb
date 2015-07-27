goods = Spree::TaxCategory.find_or_create_by!(name: "Goods")
services = Spree::TaxCategory.find_or_create_by!(name: "Services")
shipping_category = Spree::ShippingCategory.find_by_name!("Default")
service = Spree::ShippingCategory.find_by_name!("Service")

default_attrs = {
  :description => "We use only the purest pigments with the most suitable drying oils. Each colour is individually formulated to optimise and enhance the pigments’ natural characteristics to provide covering power, tinting strength and stability.

Pigments: With 80 single pigment colours, this range offers infinite colour possibilities and brighter secondary mixes.

Consistency & Texture: The buttery, stiff consistency of Artists’ Oil Colour is ideal for retaining brush or palette knife strokes and can be thinned to a very fine glaze.

Surface Sheen: The sheen reflects the pigments used and the different levels of oil in each formulation, so the gloss level varies across individual colours. This can be controlled through the selection of surface, the addition of solvent and the mediums used.",
  :available_on => Time.zone.now
}

products = [
  {
    :name => "Winsor & Newton Artists' Oil Colours Titanium White 37mL",
    :tax_category => goods,
    :shipping_category => shipping_category,
    :price => 12.40
  },
  {
    :name => "Winsor & Newton Artists' Oil Colours Titanium White 120mL",
    :tax_category => goods,
    :shipping_category => shipping_category,
    :price => 24
  },
  {
    :name => "Winsor & Newton Artists' Oil Colours Winsor Green (Yellow Shade) 37mL",
    :tax_category => goods,
    :shipping_category => shipping_category,
    :price => 15.60
  },
  {
    :name => "Winsor & Newton Artists' Oil Colours Winsor Green (Yellow Shade) 120mL",
    :tax_category => goods,
    :shipping_category => shipping_category,
    :price => 32
  },
]

services = [
  {
      :name => "Josef Zbukvic Workshop at The Mitchell School of Art Summer 2016",
      :tax_category => services,
      :shipping_category => service,
      :price => 750
  },
  {
      :name => "Herman Pekel Workshop at The Mitchell School of Art Summer 2016",
      :tax_category => services,
      :shipping_category => service,
      :price => 750
  }
]

products.each do |product_attrs|
  product = Spree::Product.create!(default_attrs.merge(product_attrs))
  product.save!
end

services.each do |product_attrs|
  product = Spree::Product.create!(product_attrs)
  product.save!
end

Spree::Config[:currency] = "AUD"
