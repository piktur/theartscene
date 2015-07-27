categories = Spree::Taxonomy.find_by!(name: "Categories")
brands     = Spree::Taxonomy.find_by!(name: "Brand")

products = { 
  :wnaoc_tiwh => "Winsor & Newton Artists' Oil Colours Titanium White 37mL",
  :wnaoc_tiwhm => "Winsor & Newton Artists' Oil Colours Titanium White 120mL",
  :wnaoc_wigy => "Winsor & Newton Artists' Oil Colours Winsor Green (Yellow Shade) 37mL",
  :wnaoc_wigym => "Winsor & Newton Artists' Oil Colours Winsor Green (Yellow Shade) 120mL"
}

products.each do |key, name|
  products[key] = Spree::Product.find_by!(name: name)
end

taxons = [
  {
    :name => "Categories",
    :taxonomy => categories,
    :position => 0
  },

  {
    :name => "Painting",
    :taxonomy => categories,
    :parent => "Categories",
    :position => 0
  },
  {
      :name => "Colour",
      :taxonomy => categories,
      :parent => "Painting",
      :position => 0,
      :products => []
  },
  {
        :name => "Oils",
        :taxonomy => categories,
        :parent => "Painting",
        :position => 0,
        :products => [
            products[:wnaoc_tiwh],
            products[:wnaoc_tiwhm],
            products[:wnaoc_wigy],
            products[:wnaoc_wigym]
        ]
  },
  {
        :name => "Acrylics",
        :taxonomy => categories,
        :parent => "Painting",
        :position => 1,
        :products => []
  },
  {
        :name => "Pigments",
        :taxonomy => categories,
        :parent => "Painting",
        :position => 2,
        :products => []
  },


  {
      :name => "Equipment",
      :taxonomy => categories,
      :parent => "Painting",
      :position => 1,
      :products => []
  },
  {
        :name => "Brushes",
        :taxonomy => categories,
        :parent => "Equipment",
        :position => 0,
        :products => []
  },
  {
        :name => "Easels",
        :taxonomy => categories,
        :parent => "Equipment",
        :position => 1,
        :products => []
  },
  {
        :name => "Palettes",
        :taxonomy => categories,
        :parent => "Equipment",
        :position => 2,
        :products => []
  },




  {
      :name => "Drawing",
      :taxonomy => categories,
      :parent => "Categories",
      :position => 1
  },



  {
      :name => "Printmaking",
      :taxonomy => categories,
      :parent => "Categories",
      :position => 2
  },



  {
      :name => "Sculpture",
      :taxonomy => categories,
      :parent => "Categories",
      :position => 3
  },



  {
      :name => "Craft",
      :taxonomy => categories,
      :parent => "Categories",
      :position => 4
  },



  {
      :name => "Design & Architecture",
      :taxonomy => categories,
      :parent => "Categories",
      :position => 5
  },



  {
      :name => "Books",
      :taxonomy => categories,
      :parent => "Categories",
      :position => 6
  },



  {
      :name => "Videos",
      :taxonomy => categories,
      :parent => "Categories",
      :position => 7
  },

  {
      :name => "Gift Vouchers",
      :taxonomy => categories,
      :parent => "Categories",
      :position => 9
  },


  {
    :name => "Brands",
    :taxonomy => brands,
    :position => 1
  },

  {
    :name => "Winsor & Newton",
    :taxonomy => brands,
    :parent => "Brands",
    :position => 0,
    :products => [
        products[:wnaoc_tiwh],
        products[:wnaoc_tiwhm],
        products[:wnaoc_wigy],
        products[:wnaoc_wigym]
    ]
  }
]

taxons.each do |taxon_attrs|
  if taxon_attrs[:parent]
    taxon_attrs[:parent] = Spree::Taxon.where(name: taxon_attrs[:parent]).first
    Spree::Taxon.create!(taxon_attrs)
  end
end
