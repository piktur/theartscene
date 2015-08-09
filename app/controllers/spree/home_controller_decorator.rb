module Spree
  HomeController.class_eval do
    # == Source Override[1]
    # spree-multi-domain-3734b6b678ba/app/controllers/spree/home_controller_decorator.rb
    def index
      @searcher = build_searcher(params)
      @products = Spree::Product.search(params[:q]).records # @searcher.retrieve_products
      @taxonomies = get_taxonomies
    end
    # End Source Override[1]

    # https://github.com/elastic/elasticsearch-rails/blob/738c63efacc167b6e8faae3b01a1a0135cfc8bbb/elasticsearch-rails/lib/rails/templates/01-basic.rb
    def search
      @products = Spree::Product.search(params[:q]).records
      render action: 'index'
    end
  end
end