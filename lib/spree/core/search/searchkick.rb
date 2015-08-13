module Spree
  module Core
    module Search
      class Searchkick < Spree::Core::Search::Base
        attr_accessor :properties
        attr_accessor :current_user
        attr_accessor :current_currency

        # TODO Virtus model like Elasticsearch-rails for search configuration
        # Configure custom filters here lib/spree/core/product_filters.rb
        # with ActiveRecord
        # Would this be better, more efficiently handled by ElasticSearch?
        def initialize(params)
          self.current_currency = Spree::Config[:currency]
          @properties = {}
          prepare(params)
        end

        def retrieve_all
          Spree::Product.search '*'
        end

        def retrieve_products
          # Scope here or in Spree::Product model using +should_index?+?
          @products = get_base_scope
          curr_page = @properties[:page] || 1

          # TODO could this be the reason products are duplicated
          # @products.includes([:master => :prices])

          unless Spree::Config.show_products_without_price
            # https://github.com/swrobel/spree_zero_stock_products/blob/2-2-stable/app/models/product_decorator.rb
            # where(
            #   <<-SQL
            #     spree_products.id IN
            #     (
            #       SELECT product_id FROM #{Spree::Variant.table_name} v
            #       JOIN #{Spree::StockItem.table_name} i
            #       ON v.id = i.variant_id
            #       WHERE v.deleted_at IS NULL
            #       AND i.deleted_at IS NULL
            #       GROUP BY product_id
            #       HAVING SUM(count_on_hand) > 0
            #       OR MAX(
            #         CASE backorderable
            #         WHEN #{ActiveRecord::Base.connection.quoted_true} THEN 1
            #         ELSE 0
            #       END) > 0
            #     )
            #   SQL
            # )

            # Having trouble with the query
            # Spree::Product.by_store(1).joins(:prices).where("spree_prices.amount IS NOT NULL")
            # Spree::Product.joins(:prices).where("spree_prices.amount = ?", 25.40)

            # Spree::Product.where(
            #   <<-SQL
            #     spree_products.id IN
            #       (
            #         SELECT  "spree_products".* FROM "spree_products"
            #         WHERE "spree_products"."deleted_at" IS NULL
            #         ORDER BY "spree_products"."id" ASC LIMIT 1
            #
            #         SELECT  "spree_variants".* FROM "spree_variants"
            #         WHERE "spree_variants"."deleted_at" IS NULL
            #         AND "spree_variants"."product_id" = $1
            #         AND "spree_variants"."is_master" = 't'
            #         LIMIT 1  [["product_id", 1]]
            #
            #         SELECT  "spree_price_books".* FROM "spree_price_books"
            #         WHERE "spree_price_books"."default" = 't'
            #         ORDER BY "spree_price_books"."id" ASC LIMIT 1
            #         SELECT  "spree_prices".* FROM "spree_prices"
            #         WHERE "spree_prices"."variant_id" = $1
            #         AND "spree_prices"."currency" = $2
            #         AND "spree_prices"."price_book_id" = $3
            #         LIMIT 1  [["variant_id", 1], ["currency", "AUD"], ["price_book_id", 9]]
            #
            #         SELECT "spree_products".* FROM "spree_products"
            #         INNER JOIN "spree_variants" ON "spree_variants"."product_id" = "spree_products"."id"
            #         AND "spree_variants"."is_master" = 'f'
            #         AND "spree_variants"."deleted_at"
            #         IS NULL INNER JOIN "spree_prices"
            #         ON "spree_prices"."variant_id" = "spree_variants"."id"
            #         AND "spree_prices"."deleted_at" IS NULL
            #         WHERE "spree_products"."deleted_at" IS NULL
            #         AND (spree_prices.amount IS NOT NULL)
            #       )
            #   SQL
            # )

            #   @products = @products.where("spree_prices.amount IS NOT NULL").where("spree_prices.currency" => current_currency)
            @products.by_store(Spree::Store.current.id)
          end

          if @properties[:query].present?
            # TODO would be better to avoid scoping on each search
            # should just ensure products we'd exclude from the scope don't end up
            # in the elasticsearch index, Otherwise if this is not possible # @products.search(
            @products = Spree::Product.search @properties[:query],
              fields: [:name, {sku: :word_start}],
              misspellings: {edit_distance: 2},
              autocomplete: true,
              suggest: true,
              page: @properties[:page],
              per_page: @properties[:per_page],
              operator: 'or', # or 'and'
              highlight: true
          else
            @products = @products.page(curr_page).per(@properties[:per_page])
          end
        end

        def filter_by_price
          # ranges = [1..10, 11...20, 21..50, 51..100, {gt: 100}]

          # Spree::Product.search '*', where: {price: range},
          #                       facets: {price: {ranges: ranges}},
          #                       smart_facets: true,
          #                       page: @properties[:page],
          #                       per_page: @properties[:per_page]
          # Spree::Product.search '*', where: {price: {lt: 100}}, facets: {price: {to: 20, from: 21}}, smart_facets: true
          Spree::Product.search '*', facets: {price: {to: 20, from: 21}}

          # Spree::Product.search '*', where: {price: 1..10},
          #                       facets: [:price],
          #                       smart_facets: true,
          #                       page: 1,
          #                       per_page: 10
        end

        def filter_by_colour
          # Example
          # Spree::Product.search '*', where: {price: range},
          #                       facets: [:price],
          #                       smart_facets: true,
          #                       page: @properties[:page],
          #                       per_page: @properties[:per_page]
        end


        # Searchkick autocomplete, find records where name contains query fragment
        def retrieve_products_autocomplete
          # This works from rails c
          # @products.search('canson', fields: [{'name^2' => :text_start}], autocomplete: false, limit: 10).records.map {|p| p.name}
          # Spree::Product.search('cans', fields: [{name: :text_start}], limit: 10).map(&:name)
          # @products = get_base_scope

          # Spree::Product.search(@properties[:query], fields: [{name: :text_start}], limit: 10).records.map(&:name)
          # Spree::Product.search(@properties[:query], fields: [:name], operator: 'or', limit: 10).records.map(&:name)
          names = Spree::Product.search(@properties[:query], fields: [:name], operator: 'or', limit: 10).records.map {|r| {t: r.name}}
          skus = Spree::Product.search(@properties[:query], fields: [:sku], limit: 5).records.map {|r| {t: r.sku}}

          # To combine autocomplete data from multiple fields
          [ names + skus ]

          # Spree::Product.search(
          #   @properties[:query],
          #   fields: [:sku],
          #   # autocomplete: false,
          #   limit: 10).map(&:sku)

          # TODO ensure +records+ method present in future searchkick release. Considered experimental
        end

        def method_missing(name)
          if @properties.has_key? name
            @properties[name]
          else
            super
          end
        end

        protected

        # == Source Override [1]
        # spree-multi-domain-3734b6b678ba/lib/spree/search/multi_domain.rb
        def get_base_scope
          base_scope = @cached_product_group ? @cached_product_group.products.active : Spree::Product.active
          base_scope = base_scope.in_taxon(taxon) unless taxon.blank?

          # Searchkick will take over from here
          base_scope = get_products_conditions_for(base_scope, keywords) unless keywords.blank?
          base_scope = add_search_scopes(base_scope)
          base_scope = add_eagerload_scopes(base_scope)
          base_scope = base_scope.by_store(@properties[:current_store_id]) if @properties[:current_store_id]
          base_scope
        end
        # END Source Override [1]

        # == Source Override [2]
        # spree-df48e629b871/core/lib/spree/core/search/base.rb
        def add_eagerload_scopes scope
          # TL;DR Switch from `preload` to `includes` as soon as Rails starts honoring
          # `order` clauses on `has_many` associations when a `where` constraint
          # affecting a joined table is present (see
          # https://github.com/rails/rails/issues/6769).
          #
          # Ideally this would use `includes` instead of `preload` calls, leaving it
          # up to Rails whether associated objects should be fetched in one big join
          # or multiple independent queries. However as of Rails 4.1.8 any `order`
          # defined on `has_many` associations are ignored when Rails builds a join
          # query.
          #
          # Would we use `includes` in this particular case, Rails would do
          # separate queries most of the time but opt for a join as soon as any
          # `where` constraints affecting joined tables are added to the search;
          # which is the case as soon as a taxon is added to the base scope.
          scope = scope.preload(master: :prices)
          scope = scope.preload(master: :images) if include_images
          scope
        end

        def add_search_scopes(base_scope)
          search.each do |name, scope_attribute|
            scope_name = name.to_sym
            if base_scope.respond_to?(:search_scopes) && base_scope.search_scopes.include?(scope_name.to_sym)
              base_scope = base_scope.send(scope_name, *scope_attribute)
            else
              base_scope = base_scope.merge(Spree::Product.ransack({scope_name => scope_attribute}).result)
            end
          end if search
          base_scope
        end

        # method should return new scope based on base_scope
        def get_products_conditions_for(base_scope, query)
          unless query.blank?
            base_scope = base_scope.like_any([:name, :description], query.split)
          end
          base_scope
        end

        def prepare(params)
          @properties[:taxon] = params[:taxon].blank? ? nil : Spree::Taxon.find(params[:taxon])
          @properties[:keywords] = params[:keywords]
          @properties[:search] = params[:search]
          @properties[:query] = params[:query]
          @properties[:include_images] = params[:include_images]

          # == Source Override [3]
          # spree-multi-domain-3734b6b678ba/lib/spree/search/multi_domain.rb
          @properties[:current_store_id] = params[:current_store_id]
          # END Source Override [3]

          per_page = params[:per_page].to_i
          @properties[:per_page] = per_page > 0 ? per_page : Spree::Config[:products_per_page]
          if params[:page].respond_to?(:to_i)
            @properties[:page] = (params[:page].to_i <= 0) ? 1 : params[:page].to_i
          else
            @properties[:page] = 1
          end
        end
          # END Source Override [2]
      end
    end
  end
end