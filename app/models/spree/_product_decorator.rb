require 'elasticsearch/model'

Spree::Product.class_eval do
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  # mappings dynamic: 'false' do
  #   indexes :name, type: 'string'
  #   indexes :description, type: 'string'
  #   # indexes :shipping_category, type: 'string'
  #   # indexes :price, type: 'integer'
  #   # indexes :available_on, type: 'string'
  # end
end

# # Spree::Product.import
#
# # @products = Spree::Product.search('winsor').records
#
# # See spree_elasticsearch/app/models/spree/product_decorator.rb
#
# # module Spree
# #   Product.class_eval do
# #     include Elasticsearch::Model::Callbacks
# #   end
# # end