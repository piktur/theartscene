australia = Spree::Country.find_or_create_by!(iso: 'AU')
nsw       = Spree::State.find_or_create_by!(abbr: 'NSW')

# Billing address
Spree::Address.create!(
    firstname:  'Associate',
    lastname:   Faker::Name.last_name,
    address1:   Faker::Address.street_address,
    address2:   Faker::Address.secondary_address,
    city:       Faker::Address.city,
    state:      nsw,
    zipcode:    2114,
    country:    australia,
    phone:      Faker::PhoneNumber.phone_number
)

Spree::Address.create!(
    firstname:  'Associate',
    lastname:   Faker::Name.last_name,
    address1:   Faker::Address.street_address,
    address2:   Faker::Address.secondary_address,
    city:       Faker::Address.city,
    state:      nsw,
    zipcode:    2114,
    country:    australia,
    phone:      Faker::PhoneNumber.phone_number
)
