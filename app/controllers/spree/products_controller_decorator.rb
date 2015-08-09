module Spree
  ProductsController.class_eval do

    # TODO for Searchkick Autocomplete implementation
    # Source https://github.com/ankane/searchkick/blob/72baec0e1fdf02559ce3e06fdccce2d6e5fb394d/README.md
    # def autocomplete
    #   render json: Spree::Product.search(params[:query], fields: [{name: :text_start}], limit: 10).map(&:name)
    # end

    # == Source Override[1]
    # See spree-multi-domain-3734b6b678ba/app/controllers/spree/products_controller_decorator.rb
    # def show
    #   @variants = @product.variants_including_master.active(current_currency).includes([:option_values, :images])
    #   @product_properties = @product.product_properties.includes(:property)
    #   @taxon = Spree::Taxon.find(params[:taxon_id]) if params[:taxon_id]
    #   redirect_if_legacy_path
    # end
    # End Source Override[1]

    # == Source Override[2]
    # See spree-multi-domain-3734b6b678ba/app/controllers/spree/products_controller_decorator.rb
    before_filter :can_show_product, :only => :show

    def index
      @searcher = build_searcher(params.merge(include_images: true))
      @products = Spree::Product.search(params[:q]).records # @searcher.retrieve_products
      @taxonomies = get_taxonomies
    end

    private

    def can_show_product
      @product ||= Spree::Product.friendly.find(params[:id])
      if @product.stores.empty? || !@product.stores.include?(current_store)
        raise ActiveRecord::RecordNotFound
      end
    end
    # Source Override[2]
  end
end

