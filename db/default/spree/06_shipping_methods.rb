# Convert raw data to Hash for processing
csv = SmarterCSV.process(
    File.join(Rails.root, 'db', 'default', 'data', '_ShippingCategories.csv')
)

csv.each do |shipping_category|
  Spree::ShippingCategory.find_or_create_by!(name: shipping_category[:name])
end

# Spree::ShippingCategory.find_or_create_by!(:name => "Default")
# Spree::ShippingCategory.find_or_create_by!(:name => "versize")
# Spree::ShippingCategory.find_or_create_by!(:name => "Heavy")
# Spree::ShippingCategory.find_or_create_by!(:name => "Hazardous")
# Spree::ShippingCategory.find_or_create_by!(:name => "Service")


# Convert raw shipping_methods data to Ruby Object for processing
csv = SmarterCSV.process(
    File.join(Rails.root, 'db', 'default', 'data', '_ShippingMethods.csv')
)

csv.each do |item|
  Spree::ShippingMethod.new do |obj|
    obj.name        = item[:name]
    obj.admin_name  = item[:admin_name]
    obj.code        = item[:code]
    obj.zones       = []

    if item[:zones].include?(',')
      item[:zones].gsub(' ', '').split!(',').each do |zone|
        obj.zones << Spree::Zone.find_by!(name: zone)
      end
    else
      obj.zones << Spree::Zone.find_by!(name: item[:zones])
    end

    case item[:calculator]
      when 'PriceSack'
        obj.calculator = Spree::Calculator::Shipping::PriceSack.create!
        obj.calculator.preferences = {
            minimal_amount: item[:minimal_amount],
            normal_amount: item[:normal_amount],
            discount_amount: item[:discount_amount],
            currency: item[:currency]
        }
        obj.calculator.save!
      when 'TieredFlatRate'
        obj.calculator = Spree::Calculator::TieredFlatRate.create!
        obj.calculator.preferences = {
            preferred_base_amount: item[:preferred_base_amount],
            preferred_tiers: {
              item[:first_tier] => item[:first_tier_amount],
              item[:second_tier] => item[:second_tier_amount]
            },
            currency: item[:currency]
        }
        obj.calculator.save!
      when 'FlatRate'
        obj.calculator = Spree::Calculator::Shipping::FlatRate.create!
        obj.calculator.preferences = {
            amount: item[:amount],
            currency: item[:currency]
        }
        obj.calculator.save!
    end

    obj.shipping_categories = []

    if item[:shipping_categories].include?(',')
      item[:shipping_categories].split(',').each do |category|
        obj.shipping_categories <<
          Spree::ShippingCategory.find_or_create_by!(name: category)
      end
    else
      obj.shipping_categories <<
          Spree::ShippingCategory.find_or_create_by!(name: item[:shipping_categories])
    end

    obj.tracking_url = item[:tracking_url] || nil
  end.save!
end

Spree::Store.all.each do |store|
  Spree::ShippingMethod.all.each do |shipping_method|
    Spree::StoreShippingMethod.create!(
        store: store,
        shipping_method: shipping_method
    )
  end
end

# Spree::ShippingMethod.create!([
#   {
#       :name => "Free Shipping to Metropolitan Sydney, Melbourne, Brisbane & Adelaide via AusPost Express Post",
#       :zones => [inner_states_metro],
#       :calculator => Spree::Calculator::Shipping::PriceSack.create!,
#       :shipping_categories => [default]
#   },
#
#   {
#       :name => "Free Shipping to Metropolitan Sydney, Melbourne, Brisbane & Adelaide via AusPost Parcel Post",
#       :zones => [inner_states_metro],
#       :calculator => Spree::Calculator::Shipping::PriceSack.create!,
#       :shipping_categories => [default]
#   },
#
#   {
#       :name => "Free Shipping to Metropolitan Sydney, Melbourne, Brisbane & Adelaide via Direct Freight",
#       :zones => [inner_states_metro],
#       :calculator => Spree::Calculator::Shipping::PriceSack.create!,
#       :shipping_categories => [default]
#   },
#
#   {
#       :name => "Free Shipping to Metropolitan Sydney, Melbourne, Brisbane & Adelaide via Fastway",
#       :zones => [inner_states_metro],
#       :calculator => Spree::Calculator::Shipping::PriceSack.create!,
#       :shipping_categories => [default]
#   },
#
#   {
#       :name => "Discounted Shipping to Regional NSW, VIC, QLD, SA & ACT via AusPost Express Post",
#       :zones => [outer_states],
#       :calculator => Spree::Calculator::Shipping::PriceSack.create!,
#       :shipping_categories => [default]
#   },
#
#   {
#       :name => "Discounted Shipping to Regional NSW, VIC, QLD, SA & ACT via AusPost Parcel Post",
#       :zones => [outer_states],
#       :calculator => Spree::Calculator::Shipping::PriceSack.create!,
#       :shipping_categories => [default]
#   },
#
#
#   {
#       :name => "Discounted Shipping to Regional NSW, VIC, QLD, SA & ACT via Direct Freight",
#       :zones => [outer_states],
#       :calculator => Spree::Calculator::Shipping::PriceSack.create!,
#       :shipping_categories => [default]
#   },
#
#   {
#       :name => "Discounted Shipping to Regional NSW, VIC, QLD, SA & ACT via Fastway",
#       :zones => [outer_states],
#       :calculator => Spree::Calculator::Shipping::PriceSack.create!,
#       :shipping_categories => [default]
#   },
#
#   {
#       :name => "Free Shipping to WA, NT & TAS via AusPost Express Post",
#       :zones => [outer_states],
#       :calculator => Spree::Calculator::Shipping::PriceSack.create!,
#       :shipping_categories => [default]
#   },
#
#   {
#       :name => "Free Shipping to WA, NT & TAS via AusPost Parcel Post",
#       :zones => [outer_states],
#       :calculator => Spree::Calculator::Shipping::PriceSack.create!,
#       :shipping_categories => [default]
#   },
#
#   {
#       :name => "Free Shipping to WA, NT & TAS via Direct Freight",
#       :zones => [outer_states],
#       :calculator => Spree::Calculator::Shipping::PriceSack.create!,
#       :shipping_categories => [default]
#   },
#
#   {
#       :name => "AusPost Express Post",
#       :zones => [australia],
#       :calculator => Spree::Calculator::Shipping::FlatRate.create!,
#       :shipping_categories => [default],
#       :tracking_url => 'http://auspost.com.au/track/track.html'
#   },
#
#   {
#       :name => "AusPost Parcel Post",
#       :zones => [australia],
#       :calculator => Spree::Calculator::Shipping::FlatRate.create!,
#       :shipping_categories => [default],
#       :tracking_url => 'http://auspost.com.au/track/track.html'
#   },
#
#   {
#       :name => "Direct Freight",
#       :zones => [australia],
#       :calculator => Spree::Calculator::Shipping::FlatRate.create!,
#       :shipping_categories => [default],
#       :tracking_url => 'http://directfreight.com.au/ConsignmentStatus.aspx'
#   },
#
#   {
#       :name => "Fastway",
#       :zones => [inner_states_metro],
#       :calculator => Spree::Calculator::Shipping::FlatRate.create!,
#       :shipping_categories => [default],
#       :tracking_url => 'http://fastway.com.au/courier-services/track-your-parcel?l='
#   },
#
#   {
#       :name => "AusPost Pack & Track International",
#       :zones => [international],
#       :calculator => Spree::Calculator::Shipping::FlatRate.create!,
#       :shipping_categories => [default],
#       :tracking_url => 'http://auspost.com.au/track/track.html'
#   },
#
#   {
#       :name => "AusPost Registered Post International",
#       :zones => [international],
#       :calculator => Spree::Calculator::Shipping::FlatRate.create!,
#       :shipping_categories => [default],
#       :tracking_url => 'http://auspost.com.au/track/track.html'
#   },
#
#   {
#       :name => "Freight at Carrier Cost",
#       :zones => [australia, international],
#       :calculator => Spree::Calculator::Shipping::FlatRate.create!,
#       :shipping_categories => [oversize, heavy, hazardous]
#   },
#
#   {
#       :name => "Service",
#       :zones => [australia, international],
#       :calculator => Spree::Calculator::Shipping::PerItem.create!,
#       :shipping_categories => [service]
#   }
# ])
#
# variable_shipping_methods = {
#     "Free Shipping to Metropolitan Sydney, Melbourne, Brisbane & Adelaide via AusPost Express Post" => [166, 10, 0, 'AUD'],
#     "Free Shipping to Metropolitan Sydney, Melbourne, Brisbane & Adelaide via AusPost Parcel Post" => [166, 10, 0, 'AUD'],
#     "Free Shipping to Metropolitan Sydney, Melbourne, Brisbane & Adelaide via Direct Freight" => [166, 10, 0, 'AUD'],
#     "Free Shipping to Metropolitan Sydney, Melbourne, Brisbane & Adelaide via Fastway" => [166, 10, 0, 'AUD'],
#     "Discounted Shipping to Regional NSW, VIC, QLD, SA & ACT via AusPost Express Post" => [166, 12, 8, 'AUD'],
#     "Discounted Shipping to Regional NSW, VIC, QLD, SA & ACT via AusPost Parcel Post" => [166, 12, 8, 'AUD'],
#     "Discounted Shipping to Regional NSW, VIC, QLD, SA & ACT via Direct Freight" => [166, 12, 8, 'AUD'],
#     "Discounted Shipping to Regional NSW, VIC, QLD, SA & ACT via Fastway" => [166, 12, 8, 'AUD'],
#     "Free Shipping to WA, NT & TAS via AusPost Express Post" => [386, 15, 0, 'AUD'],
#     "Free Shipping to WA, NT & TAS via AusPost Parcel Post" => [386, 15, 0, 'AUD'],
#     "Free Shipping to WA, NT & TAS via Direct Freight" => [386, 15, 0, 'AUD']
# }
#
# fixed_shipping_methods = {
#     "AusPost Express Post" => [10, 'AUD'],
#     "AusPost Parcel Post" => [10, 'AUD'],
#     "Direct Freight" => [10, 'AUD'],
#     "Fastway" => [10, 'AUD'],
#     "AusPost Pack & Track International" => [0, 'AUD'],
#     "AusPost Registered Post International" => [0, 'AUD'],
#     "Freight at Carrier Cost" => [0, 'AUD']
# }
#
# fixed_shipping_methods.each do |shipping_method_name, (price, currency)|
#   shipping_method = Spree::ShippingMethod.find_by_name!(shipping_method_name)
#   shipping_method.calculator.preferences = {
#       amount: price
#   }
#   shipping_method.calculator.save!
#   shipping_method.save!
# end
#
# variable_shipping_methods.each do |shipping_method_name, (minimal_amount, normal_amount, discount_amount)|
#   shipping_method = Spree::ShippingMethod.find_by_name!(shipping_method_name)
#   shipping_method.calculator.preferences = {
#     minimal_amount: minimal_amount,
#     normal_amount: normal_amount,
#     discount_amount: discount_amount
#   }
#   shipping_method.calculator.save!
#   shipping_method.save!
# end
#
# service = Spree::ShippingMethod.find_by_name!("Service")
# service.calculator.preferences = {
#     amount: 0
# }
# service.calculator.save!
# service.save!

# # =============================================================================
#   # Shipping Methods
#
# Spree::StoreShippingMethod.create([
#     {
#         shipping_method: Spree::PriceBook.find_or_create_by!(name: 'Retail'),
#         store: Spree::Store.find_by!(code: 'as'),
#         #active: true,
#         #priority: 1
#     }
# ])
#