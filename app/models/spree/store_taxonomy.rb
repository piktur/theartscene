module Spree
  class StoreTaxonomy < Spree::Base
    belongs_to :taxonomy
    belongs_to :store
  end
end