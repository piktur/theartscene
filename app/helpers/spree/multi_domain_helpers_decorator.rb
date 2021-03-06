module SpreeMultiDomain
  MultiDomainHelpers.module_eval do
    # == Source Override [1] spree-multi-domain-3734b6b678ba/lib/spree_multi_domain/multi_domain_helpers.rb:6
    # Reference join table spree_store_taxonomies rather than spree_taxonomies
    def get_taxonomies
      @taxonomies ||=
        current_store.present? ? current_store.taxonomies : Spree::Taxonomy.all
      @taxonomies = @taxonomies.includes(:root => :children)
      @taxonomies
    end
    # End Source Override [1]
  end
end