module Spree
  module Api
    ProductsHelper.module_eval do
      # TODO why not just include SpreeMultiDomain::MultiDomainHelpers.get_taxonomies
      # == Source Override[1]
      # See spree-multi-domain-3734b6b678ba/app/helpers/spree/products_helper_decorator.rb
      def get_taxonomies
        @taxonomies ||=
            current_store.present? ? current_store.taxonomies : Spree::Taxonomy.all
        @taxonomies = @taxonomies.includes(:root => :children)
        @taxonomies
      end
      # End Source Override[1]

      # == Source Override[2]
      # spree-df48e629b871/core/app/helpers/spree/products_helper.rb:54
      def cache_key_for_products
        count = @products.count
        max_updated_at = (@products.maximum(:updated_at) || Date.today).to_s(:number)
        "#{I18n.locale}/#{current_currency}/spree/products/all-#{params[:page]}-#{max_updated_at}-#{count}"
      end
      # End Source Override[2]
    end
  end
end

