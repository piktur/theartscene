taxons = []

data = File.join(Rails.root, 'db', 'default', 'data', '_Taxons(raw).csv')

# SmarterCSV.process(File.join('..', 'data', '_Taxons(raw).csv')).each do |item|
SmarterCSV.process(data).each do |item|
  item.each_with_index do |(position, value), index|
    if index == 0
      @root = value
      @parent = value

      # TODO set store_id

      taxons << {
        name:         value,
        taxonomy:     @root,
        parent:       nil,
        position:     index,
        permalink:    value.parameterize,
        description:  "Into the pit",
        meta_title:   value,
        meta_description: value,
        meta_keywords: value.downcase
      }

    else
      @struct = []

      item.map {|k, v| @struct << v unless k.to_s.to_i > index}

      permalink =
        File.join(@struct.collect {|i| i.parameterize})

      title =
        @struct.reverse.to_sentence(
          words_connector: ' | ',
          two_words_connector: ' | ',
          last_word_connector: ' | '
        )

      taxons << {
        name:         value,
        taxonomy:     @root,
        parent:       @parent,
        position:     index,
        permalink:    permalink,
        description:  "Scouring Alexandrian ruins for #{@struct[1..-1].to_sentence}",
        meta_title:   title,
        meta_description: "#{value} within #{@parent}, am I right?",
        meta_keywords: "#{@struct[1..-1].join(', ').gsub('&', 'and').downcase}"
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

# ===========================================================================
# == Create DB records
taxons = taxons.uniq!

@existent_taxons = []

until taxons.empty?
  taxons.reject! do |taxon|

    # Create taxonomies first
    if taxon[:parent].blank?
      taxonomy = Spree::Taxonomy.create!(
          name: taxon[:name],
          position: taxon[:position]
      )

      taxon[:taxonomy] = Spree::Taxonomy.find_by!(id: taxonomy.id)
      taxon[:parent] = nil

      Spree::Taxon.create!(taxon)

      Spree::Store.all.each do |store|
        Spree::StoreTaxonomy.find_or_create_by!(
          store_id: store.id,
          taxonomy_id: taxonomy.id
        )
      end

      @existent_taxons << taxon[:name]

      taxon

    # Create taxonomies first
    elsif @existent_taxons.include?(taxon[:parent])
      taxon[:taxonomy] = Spree::Taxonomy.find_by!(name: taxon[:taxonomy])
      taxon[:parent] = Spree::Taxon.find_by(name: taxon[:parent])

      Spree::Taxon.find_by(name: taxon[:name]) || Spree::Taxon.create!(taxon)

      @existent_taxons << taxon[:name]

      taxon

    end
  end
end

# ===========================================================================
# == Associate Stores and relevant Taxonomies
# TODO ensre taxonomy are assigned to a store, it is possible with current
# spree_multi_domain gem to assign multiple stores to a taxonomy. Am testing
# many_to_many or has_and_belongs_to_many association. TODO commit to clone
# Spree::Taxonomy.all.each do |t|
#   Spree::Store.all.each do |s|
#     Spree::StoreTaxonomy.create!(
#       store: s,
#       taxonomy: t
#     )
#   end
# end

# Spree::Taxonomy.all.each do |taxonomy|
#   taxonomy.store_ids = 1
#   taxonomy.save!
# end

# ===========================================================================
# == Output Taxons as csv
# CSV.open(File.join(Rails.root, 'db', 'default', 'data', '_Taxons(structured).csv'), 'wb') do |csv|
#   taxons.uniq.each do |taxon|
#     csv << taxon.values
#   end
#
#   csv
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