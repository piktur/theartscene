Spree::Taxon.class_eval do
  def self.find_by_store_id_and_permalink!(store_id, permalink)
    #joins(:taxonomy).where("spree_taxonomies.store_id = ?", store_id).where(permalink: permalink).first!
    joins(taxonomy: :stores)
    .includes(:translations)
    .where('spree_store_taxonomies.store_id' => store_id)
    .find_by!(permalink: permalink)
  end
end
