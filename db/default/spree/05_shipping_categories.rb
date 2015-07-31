require 'smarter_csv'

# Convert raw roles data Ruby Object for processing
csv = SmarterCSV.process(
    '/home/user/Desktop/artscene/spree/data/configuration/shipping_categories.csv'
)

csv.each do |item|
  Spree::Role.find_or_create_by!(name: item[:name])
end

# Spree::ShippingCategory.find_or_create_by!(:name => "Default")
# Spree::ShippingCategory.find_or_create_by!(:name => "versize")
# Spree::ShippingCategory.find_or_create_by!(:name => "Heavy")
# Spree::ShippingCategory.find_or_create_by!(:name => "Hazardous")
# Spree::ShippingCategory.find_or_create_by!(:name => "Service")
