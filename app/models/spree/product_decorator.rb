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
# Index defined in application.rb

# Delete the previous articles index in Elasticsearch
# Spree::Product.__elasticsearch__.client.indices.delete \
#   index: Spree::Product.index_name rescue nil

# Spree::Product.__elasticsearch__.create_index! force: true
# OR
# Spree::Product.__elasticsearch__.client.indices.create \
#   index: Spree::Product.index_name,
#   body: {
#       settings: Spree::Product.settings.to_hash,
#       mappings: Spree::Product.mappings.to_hash
#   }
# ===========================================================================

# To test search results undefined local variable or method `params' for #<Elasticsearch::Transport::Transport::HTTP::Faraday:0x00000004f33d70>
# $ cd /Documents/webdev/future_projects/theartscene/spree/elasticsearch-1.7.1
# $ elasticsearch/bin

# In rails console ```rails c```
# > Spree::Product.search('[search_term]').map{|record| record.[attribute]}
# ==> [...found records]

# To return ActiveRecord objects
# > search.records

# ===========================================================================

# Within attributes
# fields: [:field, :field]
# where: {
#   field:
#     # Comparison lt, gte, lte or range
#     {gt: int, lt: int}
#     int..int # equivalent to {gte: 1, lte: 10}
#     [id, id] # Find(id)
#     {not: int}
#     {not: [25, 30]}
#     {all: [1, 3]}
#     # regexp
#     /frozen .+/,
#     or: [
#       [{field: bool}]
#     ]
# order: {_score: :desc}
# limit: 20,
# offset: 40

# Spree::Product.search '',

module Spree
  Spree::Product.class_eval do
    # has_many :conversions, class: 'Spree::Search::Conversion'

    searchkick text_middle: [:description],
               word_start: [:name, :sku, :meta_keywords, :product_properties],
               facets: [:price, :taxons, :product_properties],
               autocomplete: [:name, :sku],
               highlight: [:name, :sku],
               wordnet: true,
               suggest: [:name, :sku]

               # Tolerate synonyms as defined by Wordnet
               # text_start: [:name]
               # Synch reindex, ActiveJob to run task in background
               # callbacks: :async,
               # TODO write controller to create conversions on purchase
               # conversions: 'conversions'

    # == Source Override [1]
    # spree-multi-domain-3734b6b678ba/app/models/spree/product_decorator.rb
    scope :by_store, -> (store) { joins(:stores).where("spree_products_stores.store_id = ?", store) }
    # End Source Override [1]

    # Taxons
    # Product Properties
    # Option Types
    scope :search_import, -> { includes(:variants_including_master, :taxons, :option_types, :product_properties) }

    def search_data
      data = {
        sku: self.sku,
        price: self.price,
        # product_properties: includes(:property).try(:value), # product_properties.map(&:value)
        meta_keywords: self.meta_keywords.split(',')

      # :currency, :display_amount, :display_price, :weight, :height, :width, :depth, :is_master, :has_default_price?, :cost_currency, :price_in, :amount_in
      }

      # {
      #   name: self.name,
      #   available_on: :available_on,
      #   #updated_at: updated_at,
      #

      #   description: self.try(:description),
      #   price: :price,
      #   #Spree::Product.first.product_properties.includes(:property).map(&:value)
      #   product_properties: self.includes(:property).try(:value)
      #   #option_types: [options.try(:value)],
      #   #taxons.map(&:name).uniq!,
      #   #taxons: [taxons.name]
      # }

      #     keywords: meta_keywords,
      #     # TODO Increase weight for queries with higher conversion rate
      #     # conversions: conversions.group(:query).count,
      #     # Personalised results: boost products ordered previously
      #     # orders: orders.pluck(:user_id)
      #   # END
      # }
    end

    # define filters here rather than in the controller
    # https://github.com/18F/answers/commit/1236048f43f7c1c487dad82a135b66ecd99de056
    def self.filter_by_price
      # ranges = [1..10, 11...20, 21..50, 51..100, {gt: 100}]

      # Spree::Product.search '*', where: {price: range},
      #                       facets: {price: {ranges: ranges}},
      #                       smart_facets: true,
      #                       page: @properties[:page],
      #                       per_page: @properties[:per_page]
      # Spree::Product.search '*', where: {price: {lt: 100}}, facets: {price: {to: 20, from: 21}}, smart_facets: true
      # return Spree::Product.all if query.blank?
      self.search '*', facets: {price: {to: 20, from: 21}}

      # Spree::Product.search '*', where: {price: 1..10},
      #                       facets: [:price],
      #                       smart_facets: true,
      #                       page: 1,
      #                       per_page: 10
    end

    def self.filter_by_colour
      # Example
      # Spree::Product.search '*', where: {price: range},
      #                       facets: [:price],
      #                       smart_facets: true,
      #                       page: @properties[:page],
      #                       per_page: @properties[:per_page]
    end


    # TODO scope selection to only active products
    # We'll want to limit index size to active per store
    # But in doing so we'd have to maintain an index per store.
    # Fore now we'll just rely upon the scoping setup in Spree::Search::Searchkick
    # def should_index?
    #   Spree::Product.active.by_store(current_store.id)
    # end

    private

    # def property_list
    #   product_properties.map{|pp| "#{pp.property.name}||#{pp.value}"}
    # end
  end
end

# TODO first create association User has many searches, has many orders,
# The create record on search, store params[:query] and Time searched
# https://github.com/ankane/searchkick/issues/12
# @search = current_user.searches.create!(query: params[:query], searched_at: Time.now)

# Render @search in view
#     <script>
#       var searchId = <%= @search.try(:id) %>;
#     </script>

# // example uses jQuery you must set productId on your own
# $.post("/searches/" + searchId + "/conversion", {product_id: productId});

# In Spree::Search::Conversion Model
# def conversion
#   search = current_user.searches.find(params[:id)
#   if !search.converted_at
#     search.converted_at = Time.now
#     search.product_id = params[:product_id]
#     search.save!
#   end
#   render nothing: true
# end

# Synchronise spree_products table and Elasticsearch indexing
# Spree::Product.reindex
# Spree::Product.import

