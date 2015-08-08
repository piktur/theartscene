module Spree
  module Admin
    ProductsController.class_eval do

      def autocomplete
        render json: Spree::Product.search(params[:query], fields: [{name: :text_start}], limit: 10).map(&:name)
      end
    end
  end
end

