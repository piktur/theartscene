module Spree
  HomeController.class_eval do
    # == Source Override[1]
    # spree-multi-domain-3734b6b678ba/app/controllers/spree/home_controller_decorator.rb
    def index
      # @searcher = build_searcher(params.merge(current_store_id: current_store.id))
      @searcher = build_searcher(params)
      @products = @searcher.retrieve_products || Spree::Product.all
      @taxonomies = get_taxonomies
    end
    # End Source Override[1]
  end
end