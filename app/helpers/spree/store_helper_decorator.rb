# Methods added to this helper will be available to all templates in the frontend.
module Spree
  StoreHelper.module_eval do
    def phone
      Spree::StockLocation.find_by!(default: true).phone
    end

    def email
      current_store.mail_from_address
    end

    # Source Override [1]
    # spree-df48e629b871/frontend/app/helpers/spree/store_helper.rb
    def cache_key_for_taxons
      max_updated_at = @taxons.maximum(:updated_at).to_i
      parts = [@taxon.try(:id), max_updated_at].compact.join("-")
      "#{I18n.locale}/taxons/#{parts}"
    end
  end
end
