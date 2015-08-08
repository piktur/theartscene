# ===========================================================================
# == Full text search with Elasticsearch

# ===========================================================================
# # Refer to implementation guides here https://github.com/elastic/elasticsearch-rails/tree/master/elasticsearch-model#updating-the-documents-in-the-index

# Refer to elasticsearch configuration here
# == config/application.rb:29
# ===========================================================================
# == Structure the results payload
#
# See spree_elasticsearch/app/models/spree/product_decorator.rb
# For full control on the payload overwrite the as_indexed_json method

# class Spree::Product < ActiveRecord::Base
#   include Elasticsearch::Model
#   include Elasticsearch::Model::Callbacks
#
#   def as_indexed_json(options={})
#     {
#         "title" => title,
#         "author_name" => author.name
#     }
#   end
# end
# ===========================================================================


# ===========================================================================
# == Create index
#
# Spree::Product.__elasticsearch__.create_index! force: true
# ===========================================================================

# To test search results
# $ cd /Documents/webdev/future_projects/theartscene/spree/elasticsearch-1.7.1
# $ elasticsearch/bin

# In rails console ```rails c```
# > Spree::Product.search('[search_term]').map{|record| record.[attribute]}
# ==> [...found records]

# To return ActiveRecord objects
# > search.records

require 'elasticsearch/model'

Spree::Product.class_eval do
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  # If mappings dynamic: true, then all Spree::Product attributes will be used
  # to build the index.
  # Othewise, for full control on the index composition define the mappings in the model
  # class and pass the option dynamic set to false:
  mappings dynamic: 'false' do
    indexes :name, type: 'string', analyzer: 'snowball', boost: 80
    indexes :description, type: 'string', analyzer: 'snowball', boost: 80
    # indexes :shipping_category, type: 'string'
    indexes :price, type: 'integer'
    indexes :available_on, type: 'string'
    indexes :sku, type: 'string', analyzer: 'snowball', boost: 80
  end

  def self.search(query)
    __elasticsearch__.search(
      {
        query: {
          multi_match: {
            query: query,
            # Boost likely search term candidates
            fields: [
              'name^10',
              'sku^10',
              'description'
            ]
          }
        },

        # fuzziness represents the maximum allowed Levenshtein distance, it
        # accepts an integer between 0 and 2 (where 2 means the fuzziest search
        # possible) or the string “AUTO” which will generate an edit distance
        # based on the charachers length of the terms in the query.
        # TODO test effectiveness of maximum fuzziness '2' or 'AUTO'
        fuzziness: 'AUTO',

        # Highlight search phrase occurrences within results
        highlight: {
          pre_tags: ['<strong>'],
          post_tags: ['</strong>'],
          fields: {
            name: {},
            description: {}
          }
        }
      }
    )
  end
end

# Delete the previous articles index in Elasticsearch
# Spree::Product.__elasticsearch__.client.indices.delete \
#   index: Spree::Product.index_name rescue nil
#
# Create the new index with the new mapping
# Spree::Product.__elasticsearch__.client.indices.create \
#   index: Spree::Product.index_name,
#   body: {
#     settings: Spree::Product.settings.to_hash,
#     mappings: Spree::Product.mappings.to_hash
#   }

# Synchronise spree_products table and Elasticsearch indexing
Spree::Product.import




