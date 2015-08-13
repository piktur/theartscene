module Spree
  ProductsController.class_eval do
    before_action :load_product, only: :show
    before_action :load_taxon, only: :index

    rescue_from ActiveRecord::RecordNotFound, :with => :render_404
    helper 'spree/taxons'

    respond_to :html, :xml, :json

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
      @products = @searcher.retrieve_products
      @taxonomies = get_taxonomies
    end

    # TODO Searchkick Autocomplete implementation
    # OR this via the Spree API
    # Source https://github.com/ankane/searchkick/blob/72baec0e1fdf02559ce3e06fdccce2d6e5fb394d/README.md
    def autocomplete
      @searcher = build_searcher(params.merge(autocomplete: true))
      render json: (@searcher.retrieve_products_autocomplete)
    end

    private

    def can_show_product
      @product ||= Spree::Product.friendly.find(params[:id])
      if @product.stores.empty? || !@product.stores.include?(current_store)
        raise ActiveRecord::RecordNotFound
      end
    end
    # End Source Override[2]
  end
end

