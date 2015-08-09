# Convert raw data to Hash for processing
csv = SmarterCSV.process(
    File.join(Rails.root, 'db', 'default', 'data', '_StockLocations.csv')
)

csv.each do |item|
  country = Spree::Country.find_by!(iso: item[:country])

  Spree::StockLocation.find_or_create_by!(
    {
      name:         item[:name],
      active:       item[:active] == 1 ? true : false,
      default:      item[:default] == 1 ? true : false,
      backorderable_default: item[:backorderable] == 1 ? true : false,
      propagate_all_variants: item[:propagate],
      address1:     item[:address1],
      address2:     item[:address2],
      city:         item[:city],
      state:        Spree::State.find_by!(country: country, abbr: item[:state]),
      country:      country,
      zipcode:      item[:zipcode],
      phone:        item[:phone]
    }
  )
end

Spree::Variant.all.each do |variant|
  variant.stock_items.each do |stock_item|
    Spree::StockMovement.create(
      quantity: 50,
      stock_item: stock_item
    )
  end
end

# state   = Spree::State.find_by!(abbr: 'NSW')
#
# Spree::StockLocation.create!(
#   name: 'West Ryde',
#   address1: '914 Victoria Road',
#   city: 'West Ryde',
#   zipcode: '2114',
#   country: country,
#   state: state,
#   active: true
# )
