# spree_price_books-ff06cba70d07/app/helpers/spree/base_helper_decorator.rb
module Spree
  BaseHelper.class_eval do
    # Spree 3-0-stable 3.0.3-beta
    # def display_price(product_or_variant)
    #   product_or_variant.price_in(current_currency).display_price.to_html
    # end
    # TODO HACK have had to do some serious nastiness to get this going for the demo do not let this one through
    def display_price(product_or_variant)
      product_or_variant.price_in('AUD', 1, 1)
    end
  end
end
