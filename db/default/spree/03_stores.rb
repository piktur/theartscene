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

csv = SmarterCSV.process(File.join(Rails.root, 'db', 'default', 'data', '_Stores.csv'))

csv.each do |item|
  Spree::Store.create!(
    name:           item[:name],
    default:        item[:default] == 1 ? true : false,
    code:           item[:code],
    # Add development domains
    url:            "#{item[:code]}.dev:3000, #{item[:url]}",
    mail_from_address: item[:mail_from_address],
    meta_description: item[:meta_description],
    meta_keywords:  item[:meta_keywords],
    seo_title:      item[:seo_title],
    default_currency: item[:default_currency],
    logo_file_name: item[:logo_file_name]
    # [
    #   item[:logo_file_name],
    #   item[:logo_file_name_base64],
    #   item[:logo_file_name_png],
    #   item[:logo_file_name_webp]
    # ]
  )

  # Spree::Store.find_by!(code: item[:code]).url = "#{item[:code]}.dev:3000, #{item[:url]}"
end



# Spree::Store.new do |s|
#   s.code              = 'as'
#   s.name              = 'The Art Scene'
#   s.url               = 'artscene.com.au'
#   s.mail_from_address = 'piktur.io@gmail.com'
#   s.meta_description  = "Retailer of Artists' Supplies"
#   s.meta_keywords     = 'art supplies, retail'
#   s.seo_title         = 'The Art Scene'
#   s.default_currency  = 'AUD'
#   s.default           = true
#   s.logo_file_name    = 'spree/logo/as/logo_lo.svg'
# end.save!
#
# Spree::Store.new do |s|
#   s.code              = 'aas'
#   s.name              = 'Australian Art Supplies'
#   s.url               = 'australianartsupplies.com.au'
#   s.mail_from_address = 'piktur.io@gmail.com'
#   s.meta_description  = "Retailer of Artists' Supplies"
#   s.meta_keywords     = 'art supplies, retail'
#   s.seo_title         = 'Australian Art Supplies'
#   s.default_currency  = 'AUD'
#   s.default           = false
#   s.logo_file_name    = 'spree/logo/aas/logo_lo.svg'
# end.save!
#
# Spree::Store.new do |s|
#   s.code              = 'ab'
#   s.name              = 'Art Basics'
#   s.url               = 'artbasics.com.au'
#   s.mail_from_address = 'piktur.io@gmail.com'
#   s.meta_description  = "Wholesaler of Artists' Supplies"
#   s.meta_keywords     = 'wholesale'
#   s.seo_title         = 'Art Basics'
#   s.default_currency  = 'AUD'
#   s.default           = false
#   s.logo_file_name    = 'spree/logo/ab/logo_lo.svg'
# end.save!