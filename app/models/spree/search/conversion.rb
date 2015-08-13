module Spree
  module Search

    # Simple conversion metric tracking search query terms and products purchased.
    # Query terms with higher conversion rate are weighted higher in future searches.

    # TODO Additional tracking paramaters
    #   - user interests
    class Conversion < ActiveRecord::Base
      belongs_to :product

      # TODO create conversion on purchase
      # Go easy on this one, we don't want to be re-indexing too often.
      # after_commit :reindex_product

      # TODO Reindex daily via delayed job.
      # rake searchkick:reindex CLASS=Product
    end
  end
end