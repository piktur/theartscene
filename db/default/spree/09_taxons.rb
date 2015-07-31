require 'roo'
require 'smarter_csv'

# default_attributes = {
#     store: [1,2,3,4]
# }

# taxonomies = [
#     {
#         name: 'Department',
#         position: 0
#         # store: [1,2,3,4]
#     },
#
#     {
#         name: 'Brand',
#         position: 1
#         # store: [1,2,3,4]
#     },
#
#     {
#         name: 'Manufacturer',
#         position: 2
#         # store: [1,2,3,4]
#     }
# ]
#
# taxonomies.each do |taxonomy|
#   #Spree::Taxonomy.create!(default_attributes.merge(taxonomy_attrs))
#   Spree::Taxonomy.find_or_create_by!(name: taxonomy[:name])
# end

taxons = []

# Convert raw taxonomy structure Ruby Object for processing
csv = SmarterCSV.process('/home/user/Desktop/artscene/spree/data/configuration/taxons.csv')

csv.each do |item|
  item.each_with_index do |(position, value), index|

    if index == 0
      @root = value
      taxons << {
        name: value,
        taxonomy: @root,
        position: index,
        permalink: '',
        description: '',
        meta_title: '',
        meta_description: '',
        meta_keywords: ''
      }
      @parent = value

    else
      taxons << {
        name: value,
        taxonomy: @root,
        parent: @parent,
        position: index,
        permalink: '',
        description: '',
        meta_title: '',
        meta_description: '',
        meta_keywords: ''
        # See product relationship techniques below
        #products: [
            # products[:wnaoc_tiwh],
            # products[:wnaoc_tiwhm],
            # products[:wnaoc_wigy],
            # products[:wnaoc_wigym]
        #]
      }
      @parent = value
    end
  end
end

taxons.uniq.each do |taxon|
  taxon[:taxonomy] = Spree::Taxonomy.find_or_create_by!(name: taxon[:taxonomy])

  if taxon[:parent]
    taxon[:parent] = Spree::Taxon.find_or_create_by!(name: taxon[:parent])

    Spree::Taxon.create!(taxon)
  end
end

# ===========================================================================
# Output Taxons as csv
# csv_out = Roo::CSV.new('/home/user/Desktop/artscene/spree/data/taxons_out.csv')

# taxons.collect! {|taxon| taxon.values}.to_csv

# CSV.open(csv_out, 'w+') do |csv|
#   taxons.each do |taxon|
#     csv << taxon.values
#   end
#   csv.to_csv
# end
# ===========================================================================

# ===========================================================================
# spree_product_taxons relationship should be setup at product creation. But
# if it is required to add products at taxon creation do as follows;

  # products = {
  #   :wnaoc_tiwh => "Winsor & Newton Artists' Oil Colours Titanium White 37mL",
  #   :wnaoc_tiwhm => "Winsor & Newton Artists' Oil Colours Titanium White 120mL",
  #   :wnaoc_wigy => "Winsor & Newton Artists' Oil Colours Winsor Green (Yellow Shade) 37mL",
  #   :wnaoc_wigym => "Winsor & Newton Artists' Oil Colours Winsor Green (Yellow Shade) 120mL"
  # }

  # products.each do |key, name|
  #   products[key] = Spree::Product.find_by!(name: name)
  # end
# ===========================================================================