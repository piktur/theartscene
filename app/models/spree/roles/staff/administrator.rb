module Spree
  module Roles
    module Staff
      class Administrator
        include CanCan::Ability

        def initialize(user)
          can :create, Spree::Order

          # or permissions by group
          # if spree_user.has_spree_role? 'admin'
          #   can :create, Spree::Order
          # end
        end
      end
    end
  end
end

# TODO Refer to example spree/core/app/models/spree/ability.rb
# user ||= Spree.user_class.new
#
# if user.respond_to?(:has_spree_role?) && user.has_spree_role?('admin')
#   can :manage, :all
# else
#   can :display, Country
#   can :display, OptionType
#   can :display, OptionValue
#   can :create, Order
#   can [:read, :update], Order do |order, token|
#     order.user == user || order.guest_token && token == order.guest_token
#   end
#   can :display, CreditCard, user_id: user.id
#   can :display, Product
#   can :display, ProductProperty
#   can :display, Property
#   can :create, Spree.user_class
#   can [:read, :update, :destroy], Spree.user_class, id: user.id
#   can :display, State
#   can :display, Taxon
#   can :display, Taxonomy
#   can :display, Variant
#   can :display, Zone
# end