australia = Spree::Zone.find_by!(name: "Australia")

inner_states_metro = Spree::Zone.create!(
    name: "inner_states_metro",
    description: "Metropolitan Sydney, Melbourne, Brisbane & Adelaide"
)

inner_states_regional = Spree::Zone.create!(
    name: "inner_states_regional",
    description: "Regional NSW, VIC, QLD, SA & ACT"
)

outer_states = Spree::Zone.create!(
    name: "outer_states",
    description: "WA, NT & TAS"
)

international = Spree::Zone.create!(
    name: "international",
    description: "International"
)

# TODO should demarcate Zones by City rather than State
["New South Wales", "Victoria", "Queensland", "South Australia"].each do |name|
  inner_states_metro.zone_members.create!(zoneable: Spree::State.find_by!(name: name))
end

["New South Wales", "Victoria", "Queensland", "South Australia", "Australian Capital Territory"].each do |name|
  inner_states_regional.zone_members.create!(zoneable: Spree::State.find_by!(name: name))
end

["Western Australia", "Tasmania", "Northern Territory"].each do |name|
  inner_states_regional.zone_members.create!(zoneable: Spree::State.find_by!(name: name))
end

default = Spree::ShippingCategory.find_or_create_by!(name: 'Default')
oversize = Spree::ShippingCategory.find_or_create_by!(name: 'Oversize')
heavy = Spree::ShippingCategory.find_or_create_by!(name: 'Heavy')
hazardous = Spree::ShippingCategory.find_or_create_by!(name: 'Hazardous')

Spree::ShippingMethod.create!([
  {
      :name => "Free Shipping to Metropolitan Sydney, Melbourne, Brisbane & Adelaide via AusPost Express Post",
      :zones => [inner_states_metro],
      :calculator => Spree::Calculator::Shipping::PriceSack.create!(
          minimal_amount: 166,
          normal_amount: 10,
          discount_amount: 0
      ),
      :shipping_categories => [default]
  },

  {
      :name => "Free Shipping to Metropolitan Sydney, Melbourne, Brisbane & Adelaide via AusPost Parcel Post",
      :zones => [inner_states_metro],
      :calculator => Spree::Calculator::Shipping::PriceSack.create!(
          minimal_amount: 166,
          normal_amount: 10,
          discount_amount: 0
      ),
      :shipping_categories => [default]
  },

  {
      :name => "Free Shipping to Metropolitan Sydney, Melbourne, Brisbane & Adelaide via Direct Freight",
      :zones => [inner_states_metro],
      :calculator => Spree::Calculator::Shipping::PriceSack.create!(
          minimal_amount: 166,
          normal_amount: 10,
          discount_amount: 0
      ),
      :shipping_categories => [default]
  },

  {
      :name => "Free Shipping to Metropolitan Sydney, Melbourne, Brisbane & Adelaide via Fastway",
      :zones => [inner_states_metro],
      :calculator => Spree::Calculator::Shipping::PriceSack.create!(
          minimal_amount: 166,
          normal_amount: 10,
          discount_amount: 0
      ),
      :shipping_categories => [default]
  },

  {
      :name => "Discounted Shipping to Regional NSW, VIC, QLD, SA & ACT via AusPost Express Post",
      :zones => [outer_states],
      :calculator => Spree::Calculator::Shipping::PriceSack.create!(
          minimal_amount: 166,
          normal_amount: 12,
          discount_amount: 8
      ),
      :shipping_categories => [default]
  },

  {
      :name => "Discounted Shipping to Regional NSW, VIC, QLD, SA & ACT via AusPost Parcel Post",
      :zones => [outer_states],
      :calculator => Spree::Calculator::Shipping::PriceSack.create!(
          minimal_amount: 166,
          normal_amount: 12,
          discount_amount: 8
      ),
      :shipping_categories => [default]
  },


  {
      :name => "Discounted Shipping to Regional NSW, VIC, QLD, SA & ACT via Direct Freight",
      :zones => [outer_states],
      :calculator => Spree::Calculator::Shipping::PriceSack.create!(
          minimal_amount: 166,
          normal_amount: 12,
          discount_amount: 8
      ),
      :shipping_categories => [default]
  },

  {
      :name => "Discounted Shipping to Regional NSW, VIC, QLD, SA & ACT via Fastway",
      :zones => [outer_states],
      :calculator => Spree::Calculator::Shipping::PriceSack.create!(
          minimal_amount: 166,
          normal_amount: 12,
          discount_amount: 8
      ),
      :shipping_categories => [default]
  },

  {
      :name => "Free Shipping to WA, NT & TAS via AusPost Express Post",
      :zones => [outer_states],
      :calculator => Spree::Calculator::Shipping::PriceSack.create!(
          minimal_amount: 386,
          normal_amount: 15,
          discount_amount: 0
      ),
      :shipping_categories => [default]
  },

  {
      :name => "Free Shipping to WA, NT & TAS via AusPost Parcel Post",
      :zones => [outer_states],
      :calculator => Spree::Calculator::Shipping::PriceSack.create!(
          minimal_amount: 386,
          normal_amount: 15,
          discount_amount: 0
      ),
      :shipping_categories => [default]
  },

  {
      :name => "Free Shipping to WA, NT & TAS via Direct Freight",
      :zones => [outer_states],
      :calculator => Spree::Calculator::Shipping::PriceSack.create!(
          minimal_amount: 386,
          normal_amount: 15,
          discount_amount: 0
      ),
      :shipping_categories => [default]
  },

  {
      :name => "AusPost Express Post",
      :zones => [australia],
      :calculator => Spree::Calculator::Shipping::FlatRate.create!(amount: 10),
      :shipping_categories => [default],
      :tracking_url => 'http://auspost.com.au/track/track.html'
  },

  {
      :name => "AusPost Parcel Post",
      :zones => [australia],
      :calculator => Spree::Calculator::Shipping::FlatRate.create!(amount: 10),
      :shipping_categories => [default],
      :tracking_url => 'http://auspost.com.au/track/track.html'
  },

  {
      :name => "Direct Freight",
      :zones => [australia],
      :calculator => Spree::Calculator::Shipping::FlatRate.create!(amount: 10),
      :shipping_categories => [default],
      :tracking_url => 'http://directfreight.com.au/ConsignmentStatus.aspx'
  },

  {
      :name => "Fastway",
      :zones => [inner_states_metro],
      :calculator => Spree::Calculator::Shipping::FlatRate.create!(amount: 10),
      :shipping_categories => [default],
      :tracking_url => 'http://fastway.com.au/courier-services/track-your-parcel?l='
  },

  {
      :name => "AusPost Pack & Track International",
      :zones => [international],
      :calculator => Spree::Calculator::Shipping::FlatRate.create!(amount: 0),
      :shipping_categories => [default],
      :tracking_url => 'http://auspost.com.au/track/track.html'
  },

  {
      :name => "AusPost Registered Post International",
      :zones => [international],
      :calculator => Spree::Calculator::Shipping::FlatRate.create!(amount: 0),
      :shipping_categories => [default],
      :tracking_url => 'http://auspost.com.au/track/track.html'
  },

  {
      :name => "Freight at Carrier Cost",
      :zones => [australia, international],
      :calculator => Spree::Calculator::Shipping::FlatRate.create!(amount: 0),
      :shipping_categories => [oversize, heavy, hazardous]
  }
])
