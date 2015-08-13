# au = Spree::Country.find_by(iso: 'AU')
# us = Spree::Country.find_by(iso: 'US')
# products = Spree::Product.count
# product_in_range = rand(products)
# nsw = Spree::State.find_by(country: au, abbr: 'NSW')
# tas = Spree::State.find_by(country: au, abbr: 'TAS')
# ny = Spree::State.find_by(country: us, abbr: 'NY')
# sydney = [1000..1404, 1411..1920, 2000..2249, 2555..2574, 2740..2786].collect {|i| Range === i ? i.entries : i}.flatten
# metro = sydney.sample
# # create payments based on the totals since they can't be known in YAML (quantities are random)
# method = Spree::PaymentMethod.find_by(name: 'Credit Card', active: true)
# user = Spree::User.find_by!(id: 1)
#
# def date_within_fy
#   # Create orders within fiscal year date range
#   fy_start = Time.parse('01/07/2014')
#   fy_end = Time.parse('30/06/2015')
#
#   Time.at((fy_end.to_f - fy_start.to_f) * rand + fy_start.to_f)
# end
#
#
# # Hack the current method so we're able to return a gateway without a RAILS_ENV
# Spree::Gateway.class_eval do
#   def self.current
#     Spree::Gateway::Bogus.new
#   end
# end
#
# # This table was previously called spree_creditcards, and older migrations
# # reference it as such. Make it explicit here that this table has been renamed.
# Spree::CreditCard.table_name = 'spree_credit_cards'
#
# def creditcard(fname, sname)
#   Spree::CreditCard.create(
#     cc_type: 'visa',
#     month: 12,
#     year: 2.years.from_now.year,
#     last_digits: '1111',
#     name: [fname, sname].join(' '),
#     gateway_customer_profile_id: 'BGS-1234'
#   )
# end
#
# def random_order(product, zipcode, country, state, time, options={})
#   default_options = {
#     fname: nil,
#     sname: nil,
#     payment: false,
#     payment_method: nil
#   }
#
#   options = options.reverse_merge(default_options)
#
#   # user = Spree::User.find_or_create_by!(
#   #   email:        Faker::Internet.email,
#   #   # encrypted_password: 'spree123',
#   #   subscribed:   true,
#   #   role:         'customer_retail'
#   # )
#
#   address = Spree::Address.create!(
#       firstname: options[:fname] || Faker::Name.first_name,
#       lastname: options[:sname] || Faker::Name.first_name,
#       address1: Faker::Address.street_address,
#       address2: Faker::Address.secondary_address,
#       city: Faker::Address.city,
#       state: state,
#       zipcode: zipcode,
#       country: country,
#       phone: Faker::PhoneNumber.phone_number
#   )
#
#   order = Spree::Order.create!(
#     number: rand(2000..2999),
#     email: 'spree@example.com',
#     user_id: 1,
#     created_by_id: 1,
#     shipping_address: address,
#     billing_address: address,
#     created_at: time,
#     store_id: 1,
#     # Determined by the Spree::Config[:currency] value
#     # that was set at the time of order.
#     # currency: 'AUD',
#     # item_total
#     # total
#     state: 'cart',
#     # payment_total
#     # payment_state
#     # completed_at
#     # adjustment_total
#     # considered_risky:
#     # additional_tax_total
#     # shipment_total: 0,
#     shipping_method_id: 19,
#     shipment_state: 'pending',
#     # promo_total
#     # channel
#     # included_tax_total
#     # item_count
#     # approver_id
#     # approved_at
#     special_instructions: Faker::Lorem.sentence,
#     # updated_at
#     last_ip_address: '127.0.0.0'
#     # guest
#     # canceled_at
#     # token
#     # canceler_id
#     # state_lock_version
#     # considered_risky
#   )
#
#   # Generate random number of line items
#   for i in 1..30 do
#     order.line_items.create!(
#       variant: Spree::Product.find_by!(id: product).master,
#       quantity: rand(1..100)
#     )
#   end
#
#   # order.line_items.each {|i| i.copy_price}
#
#   order.amount
#
#   order.save!
#   order.set_shipments_cost
#
#   if address.country.iso != 'AU'
#     order.create_tax_charge!
#
#     # Or create a different adjustment
#     # order.adjustments.create!(
#     #   amount: order.total * 0.1,
#     #   source: Spree::TaxRate.find_by!(name: 'GST'),
#     #   # order: self,
#     #   label: 'Tax',
#     #   state: 'finalized',
#     #   mandatory: true,
#     #   eligible: true,
#     #   included: true
#     # )
#   end
#
#   if options[:payment]
#     payment = order.payments.create!(
#       amount: order.total,
#       source: creditcard(options[:fname], options[:sname]).clone,
#       payment_method: options[:method]
#     )
#
#     payment.update_columns(
#       state: 'pending',
#       response_code: '12345'
#     )
#   end
#
#   order.create_proposed_shipments
#
#   order.save!
# end
#
# 100.times do |i|
#   # Local metropolitan
#   if i < 15
#     created_at = date_within_fy
#
#     random_order(product_in_range, metro, au, nsw, created_at)
#
#   # Entire state
#   elsif i.between?(15, 30)
#     created_at = date_within_fy
#
#     random_order(product_in_range, rand(2000..2999), au, nsw, created_at)
#
#   # International
#   elsif i.between?(30, 45)
#     created_at = date_within_fy
#
#     random_order(product_in_range, rand(16804..16900), us, ny, created_at)
#
#   # Outer State
#   elsif i.between?(45, 60)
#     created_at = date_within_fy
#
#     random_order(product_in_range, rand(7000..7999), au, tas, created_at)
#
#   # completed
#   elsif i.between?(60, 75)
#     created_at = date_within_fy
#
#     order = random_order(product_in_range, metro, au, nsw, created_at)
#     order.state = 'complete'
#     order.completed_at = created_at + 1.day
#     order.save!
#
#   # abandoned cart
#   elsif i.between?(75, 90)
#     created_at = date_within_fy
#
#     order = random_order(product_in_range, metro, au, nsw, created_at)
#     order.state = 'cart'
#     order.save!
#
#   # with payment
#   else
#     created_at = date_within_fy
#
#     random_order(
#       product_in_range,
#       metro,
#       au,
#       nsw,
#       created_at,
#       {
#         payment: true,
#         payment_method: method,
#         fname: Faker::Name.first_name,
#         sname: Faker::Name.last_name
#       }
#     )
#   end
# end
