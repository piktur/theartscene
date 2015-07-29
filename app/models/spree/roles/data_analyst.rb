module Spree
  module Roles
    class DataAnalyst
      include CanCan::Ability

      def initialize(user)
        # can :create, Spree::Order

        # or permissions by group
        # if spree_user.has_spree_role? 'admin'
        #   can :create, Spree::Order
        # end
      end
    end
  end
end
