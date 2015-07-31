Spree::User.create!(
  [
    {
      name: 'Daniel Small',
      email: 'piktur.io@gmail.com',
      role_id: 1,
      #ship_address_id: Spree::Address.find_by!(firstname: 'Daniel'),
      #bill_address_id: Spree::Address.find_by!(firstname: 'Daniel'),
      subscribed: true
    },

    {
      name: 'Staff Member',
      email: 'piktur.io@gmail.com',
      role_id: 1,
      #ship_address_id: Spree::Address.find_by!(firstname: 'Daniel'),
      #bill_address_id: Spree::Address.find_by!(firstname: 'Daniel'),
      subscribed: true
    },
  ]
)
