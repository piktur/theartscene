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

# require 'elasticsearch/model'

module Spree
  Product.class_eval do
    include Elasticsearch::Model
    # include Elasticsearch::Model::Callbacks

    index_name Spree::ElasticsearchSettings.index
    document_type 'spree_product'

    # If mappings dynamic: true, then all Spree::Product attributes will be used
    # to build the index.
    # Othewise, for full control on the index composition define the mappings in the model
    # class and pass the option dynamic set to false:

    # Source https://github.com/noname00000123/elasticsearch-rails/blob/master/elasticsearch-rails/lib/rails/templates/searchable.rb
    settings index: { number_of_shards: 1, number_of_replicas: 0 } do
      mapping do
        indexes :name, type: 'multi_field' do
          indexes :name,     analyzer: 'snowball'
          indexes :tokenized, analyzer: 'simple'
        end

        indexes :description, type: 'multi_field' do
          indexes :description,   analyzer: 'snowball'
          indexes :tokenized, analyzer: 'simple'
        end

        # indexes :content, type: 'multi_field' do
        #   indexes :content,   analyzer: 'snowball'
        #   indexes :tokenized, analyzer: 'simple'
        # end
        #
        # indexes :published_on, type: 'date'
        #
        # indexes :authors do
        #   indexes :full_name, type: 'multi_field' do
        #     indexes :full_name
        #     indexes :raw, analyzer: 'keyword'
        #   end
        # end
        #
        # indexes :categories, analyzer: 'keyword'
        #
        # indexes :comments, type: 'nested' do
        #   indexes :body, analyzer: 'snowball'
        #   indexes :stars
        #   indexes :pick
        #   indexes :user, analyzer: 'keyword'
        #   indexes :user_location, type: 'multi_field' do
        #     indexes :user_location
        #     indexes :raw, analyzer: 'keyword'
        #   end
        # end
      end
    end
    # mappings dynamic: 'false' do
    # or

    # Source spree_elasticsearch-53a70187871b/app/models/spree/product_decorator.rb
    # mapping _all: {
    #   'index_analyzer' => 'nGram_analyzer',
    #   'search_analyzer' => 'whitespace_analyzer'} do
    #
    #   indexes :name, type: 'multi_field' do
    #     indexes :name, type: 'string', analyzer: 'nGram_analyzer', boost: 100
    #     indexes :untouched, type: 'string', include_in_all: false, index: 'not_analyzed'
    #   end
    #
    #   indexes :description, analyzer: 'snowball'
    #   indexes :available_on, type: 'date', format: 'dateOptionalTime', include_in_all: false
    #   indexes :price, type: 'double'
    #   indexes :sku, type: 'string', index: 'not_analyzed'
    #   indexes :taxon_ids, type: 'string', index: 'not_analyzed'
    #   indexes :properties, type: 'string', index: 'not_analyzed'
    # end

    # Set up callbacks for updating the index on model changes
    # after_commit lambda {
    #   Indexer.perform_async(:index,  self.class.to_s, self.id)
    # }, on: :create
    #
    # after_commit lambda {
    #   Indexer.perform_async(:update, self.class.to_s, self.id)
    # }, on: :update
    #
    # after_commit lambda {
    #   Indexer.perform_async(:delete, self.class.to_s, self.id)
    # }, on: :destroy
    #
    # after_touch  lambda {
    #   Indexer.perform_async(:update, self.class.to_s, self.id)
    # }

    def as_indexed_json(options={})
      # hash = self.as_json(
      #     include: { authors:    { methods: [:full_name], only: [:full_name] },
      #                comments:   { only: [:body, :stars, :pick, :user, :user_location] }
      #     })
      # hash['categories'] = self.categories.map(&:title)
      # hash
      # result =
      #   as_json({
      #     methods: [:price, :sku],
      #     only: [:available_on, :description, :name],
      #     include: {
      #       variants: {
      #         only: [:sku],
      #         include: {
      #           option_values: {
      #             only: [:name, :presentation]
      #           }
      #         }
      #       }
      #     }
      #   })
      # result[:properties] = property_list unless property_list.empty?
      # result[:taxon_ids] =
      #   taxons.map(&:self_and_ancestors).flatten.uniq.map(&:id) unless taxons.empty?
      #
      # result
    end

    # Search in title and content fields for `query`, include highlights in response
    #
    # @param query [String] The user query
    # @return [Elasticsearch::Model::Response::Response]
    # Source https://github.com/elastic/elasticsearch-rails/blob/738c63efacc167b6e8faae3b01a1a0135cfc8bbb/elasticsearch-rails/lib/rails/templates/searchable.rb
    def self.search(query, options={})
      # Prefill and set the filters (top-level `filter` and `facet_filter` elements)
      __set_filters = lambda do |key, f|

        @search_definition[:filter][:and] ||= []
        @search_definition[:filter][:and]  |= [f]

        @search_definition[:facets][key.to_sym][:facet_filter][:and] ||= []
        @search_definition[:facets][key.to_sym][:facet_filter][:and]  |= [f]
      end

      @search_definition = {
          query: {},

          highlight: {
              pre_tags: ['<em class="label label-highlight">'],
              post_tags: ['</em>'],
              fields: {
                  name:    { number_of_fragments: 0 },
                  # abstract: { number_of_fragments: 0 },
                  description:  { fragment_size: 50 }
              }
          },

          filter: {},

          # facets: {
          #     categories: {
          #         terms: {
          #             field: 'categories'
          #         },
          #         facet_filter: {}
          #     },
          #     authors: {
          #         terms: {
          #             field: 'authors.full_name.raw'
          #         },
          #         facet_filter: {}
          #     },
          #     published: {
          #         date_histogram: {
          #             field: 'published_on',
          #             interval: 'week'
          #         },
          #         facet_filter: {}
          #     }
          # }
      }

      unless query.blank?
        @search_definition[:query] = {
            bool: {
                should: [
                    { multi_match: {
                        query: query,
                        fields: %w(name^10 description), # ['name^10', 'abstract^2', 'content'],
                        operator: 'and'
                    }
                    }
                ]
            }
        }
      else
        @search_definition[:query] = { match_all: {} }
        # @search_definition[:sort]  = { published_on: 'desc' }
      end

      # if options[:category]
      #   f = { term: { categories: options[:category] } }
      #
      #   __set_filters.(:authors, f)
      #   __set_filters.(:published, f)
      # end
      #
      # if options[:author]
      #   f = { term: { 'authors.full_name.raw' => options[:author] } }
      #
      #   __set_filters.(:categories, f)
      #   __set_filters.(:published, f)
      # end
      #
      # if options[:published_week]
      #   f = {
      #       range: {
      #           published_on: {
      #               gte: options[:published_week],
      #               lte: "#{options[:published_week]}||+1w"
      #           }
      #       }
      #   }
      #
      #   __set_filters.(:categories, f)
      #   __set_filters.(:authors, f)
      # end

      # if query.present? && options[:comments]
      #   @search_definition[:query][:bool][:should] ||= []
      #   @search_definition[:query][:bool][:should] << {
      #       nested: {
      #           path: 'comments',
      #           query: {
      #               multi_match: {
      #                   query: query,
      #                   fields: ['body'],
      #                   operator: 'and'
      #               }
      #           }
      #       }
      #   }
      #   @search_definition[:highlight][:fields].update 'comments.body' => { fragment_size: 50 }
      # end

      # if options[:sort]
      #   @search_definition[:sort]  = { options[:sort] => 'desc' }
      #   @search_definition[:track_scores] = true
      # end

      unless query.blank?
        @search_definition[:suggest] = {
            text: query,
            suggest_title: {
                term: {
                    field: 'name.tokenized',
                    suggest_mode: 'always'
                }
            },
            suggest_body: {
                term: {
                    field: 'description.tokenized',
                    suggest_mode: 'always'
                }
            }
        }
      end

      __elasticsearch__.search(@search_definition)
    end

    # def self.search(query)
    #   # TODO congigure advanced or combination queries later. For now happy with simple search
    #   __elasticsearch__.search(
    #     {
    #       query: {
    #         filtered: {
    #           query: {
    #             query_string: {
    #               query: query,
    #               fields: []
    #             }
    #           },
    #
    #           filter: {
    #             and: [
    #               {
    #                 terms: {
    #                   taxons: []
    #                 }
    #               },
    #
    #               {
    #                 terms: {
    #                   properties: []
    #                 }
    #               }
    #             ]
    #           }
    #         }
    #       },
    #
    #       filter: {
    #         range: {
    #           price: {
    #             lte: ,
    #             gte:
    #           }
    #         }
    #       },
    #
    #       sort: [],
    #
    #       from: ,
    #
    #       facets:
    #     },
    #
    #
    #     {
    #       query: {
    #         multi_match: {
    #           query: query,
    #           #Boost likely search term candidates
    #           fields: %w(
    #             name^10
    #             sku^10
    #             description
    #           ),
    #           fuzziness: 'AUTO',
    #           slop: 2
    #         },
    #
    #         # bool: {
    #         #   should: {
    #         #     # fuzziness represents the maximum allowed Levenshtein distance, it
    #         #     # accepts an integer between 0 and 2 (where 2 means the fuzziest search
    #         #     # possible) or the string “AUTO” which will generate an edit distance
    #         #     # based on the charachers length of the terms in the query.
    #         #     # TODO test effectiveness of maximum fuzziness '2' or 'AUTO'
    #         #     fuzzy: {
    #         #       name: {
    #         #         value: 'winsor',
    #         #         boost: 1.0,
    #         #         fuzziness: 'AUTO',
    #         #         prefix_length: 0,
    #         #         max_expansions: 100
    #         #       },
    #         #
    #         #       price: {
    #         #         value: 12,
    #         #         fuzziness: 2
    #         #       }
    #         #     }
    #         #   }
    #         # }
    #       },
    #
    #       # fuzzy_like_this_field: {
    #       #   name: {
    #       #     like_text: 'winston',
    #       #     max_query_terms: 12
    #       #   }
    #       # }
    #
    #       # Highlight search phrase occurrences within results
    #       highlight: {
    #         fields: {
    #           name: {},
    #           description: {}
    #         },
    #         pre_tags: ['<strong>'],
    #         post_tags: ['</strong>']
    #       }
    #     }
    #   )
    # end

    # Inner class used to query elasticsearch. The idea is that the query is
    # dynamically built based on the parameters.
    class Product::ElasticsearchQuery
      include ::Virtus.model

      attribute :from, Integer, default: 0
      attribute :price_min, Float
      attribute :price_max, Float
      attribute :properties, Hash
      attribute :query, String
      attribute :taxons, Array
      attribute :browse_mode, Boolean
      attribute :sorting, String

      # When browse_mode is enabled, the taxon filter is placed at top level.
      # This causes the results to be limited, but facetting is done on the
      # complete dataset.
      # When browse_mode is disabled, the taxon filter is placed inside the
      # filtered query. This causes the facets to be limited to the resulting set.

      # Method that creates the actual query based on the current attributes.
      # The idea is to always to use the following schema and fill in the blanks.
      # {
      #   query: {
      #     filtered: {
      #       query: {
      #         query_string: { query: , fields: [] }
      #       }
      #       filter: {
      #         and: [
      #           { terms: { taxons: [] } },
      #           { terms: { properties: [] } }
      #         ]
      #       }
      #     }
      #   }
      #   filter: { range: { price: { lte: , gte: } } },
      #   sort: [],
      #   from: ,
      #   facets:
      # }

      def to_hash
        q = { match_all: {} }

        unless query.blank? # nil or empty
          q = {
            query_string: {
              query: query,
              fields: %w(
                name^5
                description
              ),
              # sku
              default_operator: 'AND',
              use_dis_max: true
            }
          }
        end

        query = q

        and_filter = []

        unless @properties.nil? || @properties.empty?
          # transform properties from [{"key1" => ["value_a","value_b"]},{"key2" => ["value_a"]}
          # to { terms: { properties: ["key1||value_a","key1||value_b"] }
          #    { terms: { properties: ["key2||value_a"] }
          # This enforces "and" relation between different property values and "or" relation between same property values
          properties = @properties.map {|k,v| [k].product(v)}
          properties.map do |pair|
            and_filter << {
              terms: {
                properties: pair.map {|prop| prop.join('||')}
              }
            }
          end
        end

        sorting =
          case @sorting
            when 'name_asc'
              [ 
                {'name.untouched' => { order: 'asc' }}, 
                {'price' => { order: 'asc' }}, 
                '_score' 
              ]
              
            when 'name_desc'
              [ 
                {'name.untouched' => { order: 'desc' }}, 
                {'price' => { order: 'asc' }}, 
                '_score'
              ]
              
            when 'price_asc'
              [ 
                {'price' => { order: 'asc' }}, 
                {'name.untouched' => { order: 'asc' }}, 
                '_score' 
              ]
              
            when 'price_desc'
              [ 
                {'price' => { order: 'desc' }}, 
                {'name.untouched' => { order: 'asc' }}, 
                '_score' 
              ]
            when 'score'
              [ 
                '_score', 
                {'name.untouched' => { order: 'asc' }}, 
                {'price' => { order: 'asc' }} 
              ]
            else
              [ 
                {'name.untouched' => { order: 'asc' }}, 
                {'price' => { order: 'asc' }}, 
                '_score' 
              ]
          end

        # facets
        facets = {
          price: { 
            statistical: {field: 'price'} 
          },
          properties: { 
            terms: {field: 'properties', order: 'count', size: 1000000 }
          },
          taxon_ids: { 
            terms: {field: 'taxon_ids', size: 1000000} 
          }
        }

        # basic skeleton
        result = {
          min_score: 0.1,
          query: { filtered: {} },
          sort: sorting,
          from: from,
          facets: facets
        }

        # add query and filters to filtered
        result[:query][:filtered][:query] = query
        # taxon and property filters have an effect on the facets
        and_filter << { terms: { taxon_ids: taxons } } unless taxons.empty?
        # only return products that are available
        and_filter << { range: { available_on: { lte: "now" } } }
        result[:query][:filtered][:filter] =
          { 'and' => and_filter } unless and_filter.empty?

        # add price filter outside the query because it should have no effect on facets
        if price_min && price_max && (price_min < price_max)
          result[:filter] = {
            range: {
              price: {
                gte: price_min,
                lte: price_max
              }
            }
          }
        end

        result
      end
    end

    private

    def property_list
      product_properties.map{|pp| "#{pp.property.name}||#{pp.value}"}
    end
  end
end

# Synchronise spree_products table and Elasticsearch indexing
Spree::Product.import
