Spree::Sample.load_sample("taxonomies")
Spree::Sample.load_sample("products")

categories = Spree::Taxonomy.find_by_name!("Categories")
brands     = Spree::Taxonomy.find_by_name!("Brand")

products = { 
  :wnaoc_tiwh => "Winsor & Newton Artists' Oil Colour Titanium White",
  :wnaoc_wigy => "Winsor & Newton Artists' Oil Colour Winsor Green (Yellow Shade)"
}


products.each do |key, name|
  products[key] = Spree::Product.find_by_name!(name)
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
    :position => 1
  },
  {
      :name => "Colour",
      :taxonomy => categories,
      :parent => "Painting",
      :position => 1,
      :products => []
  },
  {
        :name => "Oils",
        :taxonomy => categories,
        :parent => "Painting",
        :position => 1,
        :products => [
            products[:wnaoc_tiwh],
            products[:wnaoc_wigy]
        ]
  },
  {
        :name => "Acrylics",
        :taxonomy => categories,
        :parent => "Painting",
        :position => 2,
        :products => []
  },
  {
        :name => "Pigments",
        :taxonomy => categories,
        :parent => "Painting",
        :position => 3,
        :products => []
  },


  {
      :name => "Equipment",
      :taxonomy => categories,
      :parent => "Painting",
      :position => 2,
      :products => []
  },
  {
        :name => "Brushes",
        :taxonomy => categories,
        :parent => "Equipment",
        :position => 2,
        :products => []
  },
  {
        :name => "Easels",
        :taxonomy => categories,
        :parent => "Equipment",
        :position => 2,
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
      :position => 2
  },



  {
      :name => "Printmaking",
      :taxonomy => categories,
      :parent => "Categories",
      :position => 3
  },



  {
      :name => "Sculpture",
      :taxonomy => categories,
      :parent => "Categories",
      :position => 4
  },



  {
      :name => "Craft",
      :taxonomy => categories,
      :parent => "Categories",
      :position => 5
  },



  {
      :name => "Design & Architecture",
      :taxonomy => categories,
      :parent => "Categories",
      :position => 6
  },



  {
      :name => "Books",
      :taxonomy => categories,
      :parent => "Categories",
      :position => 7
  },



  {
      :name => "Videos",
      :taxonomy => categories,
      :parent => "Categories",
      :position => 8
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
    :position => 1,
    :products => [
      products[:wnaoc_tiwh],
      products[:wnaoc_wigy]
    ]
  }
]

taxons.each do |taxon_attrs|
  if taxon_attrs[:parent]
    taxon_attrs[:parent] = Spree::Taxon.where(name: taxon_attrs[:parent]).first
    Spree::Taxon.create!(taxon_attrs)
  end
end
