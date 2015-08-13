module Spree
  module Core
    module ControllerHelpers
      module Search
        def build_searcher params
          Spree::Config.searcher_class.new(params).tap do |searcher|
            searcher.current_user = try_spree_current_user
            searcher.current_currency = current_currency
            # == Source Override [1]
            # spree-df48e629b871/core/lib/spree/core/controller_helpers/search.rb:16
            # searcher.current_store = current_store
            # End Source Override [1]
          end
        end
      end
    end
  end
end
