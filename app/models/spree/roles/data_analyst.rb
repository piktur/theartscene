# Example see spree/core/lib/spree/testing_support/bar_ability.rb
# class BarAbility
#   include CanCan::Ability
#
#   def initialize(user)
#     user ||= Spree::User.new
#     if user.has_spree_role? 'bar'
#       # allow dispatch to :admin, :index, and :show on Spree::Order
#       can [:admin, :index, :show], Spree::Order
#       # allow dispatch to :index, :show, :create and :update shipments on the admin
#       can [:admin, :manage], Spree::Shipment
#     end
#   end
# end

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

