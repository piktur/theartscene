products =
  {
    "Winsor & Newton Artists' Oil Colours Titanium White" =>
    {
      "Manufacturer" => "Winsor & Newton",
      "Brand" => "Artists' Oil Colours",
      "Manufacter Code" => "50730735",
      "Colour" => "Titanium White",
      "Description" => "Titanium White is a clean white pigment. It is the most opaque white pigment and is considered a standard strong white colour.",
      "Pigments" => "PW6, PW4"
    }
  },

  {
    "Winsor & Newton Artists' Oil Colours Winsor Green (Yellow Shade)" =>
    {
        "Manufacturer" => "Winsor & Newton",
        "Brand" => "Artists' Oil Colours",
        "Manufacter Code" => "50904839",
        "Colour" => "Winsor Green (Yellow Shade)",
        "Description" => "Winsor Green (Yellow Shade) is a brilliant transparent green pigment with a yellow undertone. It is made from the modern pigment Phthalocyanine which was introduced in 1930s.",
        "Pigments" => "PG36"
    }
  }

products.each do |name, properties|
  product = Spree::Product.find_by_name(name)
  properties.each do |prop_name, prop_value|
    product.set_property(prop_name, prop_value)
  end
end
