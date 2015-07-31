require 'smarter_csv'

# Convert raw roles data Ruby Object for processing
csv = SmarterCSV.process('/home/user/Desktop/artscene/spree/data/roles.csv')

csv.each do |item|
  Spree::Role.find_or_create_by!(name: item[:name])
end

# Spree::Role.where(name: 'admin').first_or_create
# # Spree::Role.where(:name => "user").first_or_create
#
# Spree::Role.create!(name: 'customer_as_retail')
# Spree::Role.create!(name: 'customer_as_retail_loyal')
#
# Spree::Role.create!(name: 'customer_ab_reseller')
# Spree::Role.create!(name: 'customer_ab_school')
#
# Spree::Role.create!(name: 'staff_sales_rep')
# Spree::Role.create!(name: 'staff_administrator')
# Spree::Role.create!(name: 'data_analyst')
# Spree::Role.create!(name: 'guest_editor')