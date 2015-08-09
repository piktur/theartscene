Spree::Store.class_eval do
  has_and_belongs_to_many :taxonomies, join_table: :spree_store_taxonomies
end
