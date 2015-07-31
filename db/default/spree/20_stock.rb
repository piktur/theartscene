country = Spree::Country.find_by!(iso: 'AU')
state   = Spree::State.find_by!(abbr: 'NSW')

Spree::StockLocation.create!(
  name: 'West Ryde',
  address1: '914 Victoria Road',
  city: 'West Ryde',
  zipcode: '2114',
  country: country,
  state: state,
  active: true
)

Spree::Variant.all.each do |variant|
  variant.stock_items.each do |stock_item|
    Spree::StockMovement.create(:quantity => 10, :stock_item => stock_item)
  end
end
