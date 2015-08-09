module Spree
  TaxonsController.class_eval do
    # == Source Override [1]
    # See spree-multi-domain-3734b6b678ba/app/controllers/spree/taxons_controller_decorator.rb:2
    def show
      @taxon = Spree::Taxon.find_by_store_id_and_permalink!(current_store.id, params[:id])
      return unless @taxon

      @searcher = build_searcher(params.merge(:taxon => @taxon.id))
      @products = Spree::Product.search(params[:q]).records # @searcher.retrieve_products
      @taxonomies = get_taxonomies
    end
    # End Source Override [1]
  end
end