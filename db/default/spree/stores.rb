# See /home/user/Documents/webdev/future_projects/theartscene/spree/theartscene/db/sample/0_stores.rb

# Possibly already created by a migration.
# unless Spree::Store.where(code: 'spree').exists?
#   Spree::Store.new do |s|
#     s.code              = 'spree'
#     s.name              = 'Spree Demo Site'
#     s.url               = 'example.com'
#     s.mail_from_address = 'spree@example.com'
#   end.save!
# end