products = {
  "Winsor & Newton Artists' Oil Colours Titanium White 37mL" =>
  {
    "Manufacturer" => "Winsor & Newton",
    "Brand" => "Artists' Oil Colours",
    "Manufacter Code" => "50730735",
    "Colour" => "Titanium White",
    "Description" => "Titanium White is a clean white pigment. It is the most opaque white pigment and is considered a standard strong white colour.",
    "Pigments" => "PW6, PW4"
  },

  "Winsor & Newton Artists' Oil Colours Titanium White 120mL" =>
  {
      "Manufacturer" => "Winsor & Newton",
      "Brand" => "Artists' Oil Colours",
      "Manufacter Code" => "50730735",
      "Colour" => "Titanium White",
      "Description" => "Titanium White is a clean white pigment. It is the most opaque white pigment and is considered a standard strong white colour.",
      "Pigments" => "PW6, PW4"
  },

  "Winsor & Newton Artists' Oil Colours Winsor Green (Yellow Shade) 37mL" =>
  {
      "Manufacturer" => "Winsor & Newton",
      "Brand" => "Artists' Oil Colours",
      "Manufacter Code" => "50904839",
      "Colour" => "Winsor Green (Yellow Shade)",
      "Description" => "Winsor Green (Yellow Shade) is a brilliant transparent green pigment with a yellow undertone. It is made from the modern pigment Phthalocyanine which was introduced in 1930s.",
      "Pigments" => "PG36"
  },

  "Winsor & Newton Artists' Oil Colours Winsor Green (Yellow Shade) 120mL" =>
  {
      "Manufacturer" => "Winsor & Newton",
      "Brand" => "Artists' Oil Colours",
      "Manufacter Code" => "50904839",
      "Colour" => "Winsor Green (Yellow Shade)",
      "Description" => "Winsor Green (Yellow Shade) is a brilliant transparent green pigment with a yellow undertone. It is made from the modern pigment Phthalocyanine which was introduced in 1930s.",
      "Pigments" => "PG36"
  },

  "Josef Zbukvic Workshop at The Mitchell School of Art Summer 2016" =>
  {
      "Date" => "18-24 January 2016",
      "Tutor" => "Josef Zbukvic",
      "Title" => "Watercolour Godhood",
      "Location" => "Charles Sturt University Campus",
      "Skill Level" => "Advanced"
  },
  "Herman Pekel Workshop at The Mitchell School of Art Summer 2016" =>
  {
      "Date" => "18-24 January 2016",
      "Tutor" => "Herman Pekel",
      "Title" => "Masterful Oil Slick",
      "Location" => "Charles Sturt University Campus",
      "Skill Level" => "Advanced"
  }
}

products.each do |name, properties|
  product = Spree::Product.find_by_name(name)
  properties.each do |prop_name, prop_value|
    product.set_property(prop_name, prop_value)
  end
end
