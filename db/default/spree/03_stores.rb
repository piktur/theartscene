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

Spree::Store.new do |s|
  s.code              = 'as'
  s.name              = 'The Art Scene'
  s.url               = 'artscene.com.au'
  s.mail_from_address = 'piktur.io@gmail.com'
  s.meta_description  = "Retailer of Artists' Supplies"
  s.meta_keywords     = 'art supplies, retail'
  s.seo_title         = 'The Art Scene'
  s.default_currency  = 'AUD'
  s.default           = true
  s.logo_file_name    = 'spree/logo/as/logo_lo.svg'
end.save!

Spree::Store.new do |s|
  s.code              = 'aas'
  s.name              = 'Australian Art Supplies'
  s.url               = 'australianartsupplies.com.au'
  s.mail_from_address = 'piktur.io@gmail.com'
  s.meta_description  = "Retailer of Artists' Supplies"
  s.meta_keywords     = 'art supplies, retail'
  s.seo_title         = 'Australian Art Supplies'
  s.default_currency  = 'AUD'
  s.default           = false
  s.logo_file_name    = 'spree/logo/aas/logo_lo.svg'
end.save!

Spree::Store.new do |s|
  s.code              = 'ab'
  s.name              = 'Art Basics'
  s.url               = 'artbasics.com.au'
  s.mail_from_address = 'piktur.io@gmail.com'
  s.meta_description  = "Wholesaler of Artists' Supplies"
  s.meta_keywords     = 'wholesale'
  s.seo_title         = 'Art Basics'
  s.default_currency  = 'AUD'
  s.default           = false
  s.logo_file_name    = 'spree/logo/ab/logo_lo.svg'
end.save!