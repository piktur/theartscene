#Convert raw data to Hash for processing
# csv = SmarterCSV.process(
#     File.join(Rails.root, 'db', 'default', 'data', '_Users.csv')
# )
#
# csv.each do |item|
#   country = Spree::Country.find_by!(iso: item[:country])
#
#   if item[:active] == 1
#     Spree::User.find_or_create_by!(
#       email:        item[:email],
#       # encrypted_password: 'spree123',
#       subscribed:   item[:subscribed],
#       # role:         item[:role],
#       ship_address_id: Spree::Address.find_or_create_by!(
#         firstname:  item[:firstname],
#         lastname:   item[:lastname],
#         company:    item[:company],
#         address1:   item[:address1],
#         address2:   item[:address2],
#         city:       item[:city],
#         state:      Spree::State.find_by!(country: country, abbr: item[:state]),
#         country:    country,
#         zipcode:    item[:postcode],
#         phone:      item[:phone] #,
#         # alt_phone:  item[:alt_phone]
#       ),
#       bill_address_id: Spree::Address.find_or_create_by!(
#         firstname:  item[:firstname],
#         lastname:   item[:lastname],
#         company:    item[:company],
#         address1:   item[:address1],
#         address2:   item[:address2],
#         city:       item[:city],
#         state:      Spree::State.find_by!(country: country, abbr: item[:state]),
#         country:    country,
#         zipcode:    item[:postcode],
#         phone:      item[:phone] #,
#         # alt_phone:  item[:alt_phone]
#       )
#     )
#   end
# end

# Spree::User.create!(
#   [
#     {
#       name: 'Daniel Small',
#       email: 'piktur.io@gmail.com',
#       role_id: 1,
#       #ship_address_id: Spree::Address.find_by!(firstname: 'Daniel'),
#       #bill_address_id: Spree::Address.find_by!(firstname: 'Daniel'),
#       subscribed: true
#     },
#
#     {
#       name: 'Staff Member',
#       email: 'piktur.io@gmail.com',
#       role_id: 1,
#       #ship_address_id: Spree::Address.find_by!(firstname: 'Daniel'),
#       #bill_address_id: Spree::Address.find_by!(firstname: 'Daniel'),
#       subscribed: true
#     },
#   ]
# )
