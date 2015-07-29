default = Spree::ShippingCategory.find_or_create_by!(name: 'default')
oversize = Spree::ShippingCategory.find_or_create_by!(name: 'oversize')
heavy = Spree::ShippingCategory.find_or_create_by!(name: 'heavy')
hazardous = Spree::ShippingCategory.find_or_create_by!(name: 'hazardous')
service = Spree::ShippingCategory.find_or_create_by!(name: 'service')

Spree::ShippingMethod.create!([
  {
      :name => "Free Shipping to Metropolitan Sydney, Melbourne, Brisbane & Adelaide via AusPost Express Post",
      :zones => [inner_states_metro],
      :calculator => Spree::Calculator::Shipping::PriceSack.create!,
      :shipping_categories => [default]
  },

  {
      :name => "Free Shipping to Metropolitan Sydney, Melbourne, Brisbane & Adelaide via AusPost Parcel Post",
      :zones => [inner_states_metro],
      :calculator => Spree::Calculator::Shipping::PriceSack.create!,
      :shipping_categories => [default]
  },

  {
      :name => "Free Shipping to Metropolitan Sydney, Melbourne, Brisbane & Adelaide via Direct Freight",
      :zones => [inner_states_metro],
      :calculator => Spree::Calculator::Shipping::PriceSack.create!,
      :shipping_categories => [default]
  },

  {
      :name => "Free Shipping to Metropolitan Sydney, Melbourne, Brisbane & Adelaide via Fastway",
      :zones => [inner_states_metro],
      :calculator => Spree::Calculator::Shipping::PriceSack.create!,
      :shipping_categories => [default]
  },

  {
      :name => "Discounted Shipping to Regional NSW, VIC, QLD, SA & ACT via AusPost Express Post",
      :zones => [outer_states],
      :calculator => Spree::Calculator::Shipping::PriceSack.create!,
      :shipping_categories => [default]
  },

  {
      :name => "Discounted Shipping to Regional NSW, VIC, QLD, SA & ACT via AusPost Parcel Post",
      :zones => [outer_states],
      :calculator => Spree::Calculator::Shipping::PriceSack.create!,
      :shipping_categories => [default]
  },


  {
      :name => "Discounted Shipping to Regional NSW, VIC, QLD, SA & ACT via Direct Freight",
      :zones => [outer_states],
      :calculator => Spree::Calculator::Shipping::PriceSack.create!,
      :shipping_categories => [default]
  },

  {
      :name => "Discounted Shipping to Regional NSW, VIC, QLD, SA & ACT via Fastway",
      :zones => [outer_states],
      :calculator => Spree::Calculator::Shipping::PriceSack.create!,
      :shipping_categories => [default]
  },

  {
      :name => "Free Shipping to WA, NT & TAS via AusPost Express Post",
      :zones => [outer_states],
      :calculator => Spree::Calculator::Shipping::PriceSack.create!,
      :shipping_categories => [default]
  },

  {
      :name => "Free Shipping to WA, NT & TAS via AusPost Parcel Post",
      :zones => [outer_states],
      :calculator => Spree::Calculator::Shipping::PriceSack.create!,
      :shipping_categories => [default]
  },

  {
      :name => "Free Shipping to WA, NT & TAS via Direct Freight",
      :zones => [outer_states],
      :calculator => Spree::Calculator::Shipping::PriceSack.create!,
      :shipping_categories => [default]
  },

  {
      :name => "AusPost Express Post",
      :zones => [australia],
      :calculator => Spree::Calculator::Shipping::FlatRate.create!,
      :shipping_categories => [default],
      :tracking_url => 'http://auspost.com.au/track/track.html'
  },

  {
      :name => "AusPost Parcel Post",
      :zones => [australia],
      :calculator => Spree::Calculator::Shipping::FlatRate.create!,
      :shipping_categories => [default],
      :tracking_url => 'http://auspost.com.au/track/track.html'
  },

  {
      :name => "Direct Freight",
      :zones => [australia],
      :calculator => Spree::Calculator::Shipping::FlatRate.create!,
      :shipping_categories => [default],
      :tracking_url => 'http://directfreight.com.au/ConsignmentStatus.aspx'
  },

  {
      :name => "Fastway",
      :zones => [inner_states_metro],
      :calculator => Spree::Calculator::Shipping::FlatRate.create!,
      :shipping_categories => [default],
      :tracking_url => 'http://fastway.com.au/courier-services/track-your-parcel?l='
  },

  {
      :name => "AusPost Pack & Track International",
      :zones => [international],
      :calculator => Spree::Calculator::Shipping::FlatRate.create!,
      :shipping_categories => [default],
      :tracking_url => 'http://auspost.com.au/track/track.html'
  },

  {
      :name => "AusPost Registered Post International",
      :zones => [international],
      :calculator => Spree::Calculator::Shipping::FlatRate.create!,
      :shipping_categories => [default],
      :tracking_url => 'http://auspost.com.au/track/track.html'
  },

  {
      :name => "Freight at Carrier Cost",
      :zones => [australia, international],
      :calculator => Spree::Calculator::Shipping::FlatRate.create!,
      :shipping_categories => [oversize, heavy, hazardous]
  },

  {
      :name => "Service",
      :zones => [australia, international],
      :calculator => Spree::Calculator::Shipping::PerItem.create!,
      :shipping_categories => [service]
  }
])

variable_shipping_methods = {
    "Free Shipping to Metropolitan Sydney, Melbourne, Brisbane & Adelaide via AusPost Express Post" => [166, 10, 0, 'AUD'],
    "Free Shipping to Metropolitan Sydney, Melbourne, Brisbane & Adelaide via AusPost Parcel Post" => [166, 10, 0, 'AUD'],
    "Free Shipping to Metropolitan Sydney, Melbourne, Brisbane & Adelaide via Direct Freight" => [166, 10, 0, 'AUD'],
    "Free Shipping to Metropolitan Sydney, Melbourne, Brisbane & Adelaide via Fastway" => [166, 10, 0, 'AUD'],
    "Discounted Shipping to Regional NSW, VIC, QLD, SA & ACT via AusPost Express Post" => [166, 12, 8, 'AUD'],
    "Discounted Shipping to Regional NSW, VIC, QLD, SA & ACT via AusPost Parcel Post" => [166, 12, 8, 'AUD'],
    "Discounted Shipping to Regional NSW, VIC, QLD, SA & ACT via Direct Freight" => [166, 12, 8, 'AUD'],
    "Discounted Shipping to Regional NSW, VIC, QLD, SA & ACT via Fastway" => [166, 12, 8, 'AUD'],
    "Free Shipping to WA, NT & TAS via AusPost Express Post" => [386, 15, 0, 'AUD'],
    "Free Shipping to WA, NT & TAS via AusPost Parcel Post" => [386, 15, 0, 'AUD'],
    "Free Shipping to WA, NT & TAS via Direct Freight" => [386, 15, 0, 'AUD']
}

fixed_shipping_methods = {
    "AusPost Express Post" => [10, 'AUD'],
    "AusPost Parcel Post" => [10, 'AUD'],
    "Direct Freight" => [10, 'AUD'],
    "Fastway" => [10, 'AUD'],
    "AusPost Pack & Track International" => [0, 'AUD'],
    "AusPost Registered Post International" => [0, 'AUD'],
    "Freight at Carrier Cost" => [0, 'AUD']
}

fixed_shipping_methods.each do |shipping_method_name, (price, currency)|
  shipping_method = Spree::ShippingMethod.find_by_name!(shipping_method_name)
  shipping_method.calculator.preferences = {
      amount: price
  }
  shipping_method.calculator.save!
  shipping_method.save!
end

variable_shipping_methods.each do |shipping_method_name, (minimal_amount, normal_amount, discount_amount)|
  shipping_method = Spree::ShippingMethod.find_by_name!(shipping_method_name)
  shipping_method.calculator.preferences = {
    minimal_amount: minimal_amount,
    normal_amount: normal_amount,
    discount_amount: discount_amount
  }
  shipping_method.calculator.save!
  shipping_method.save!
end

service = Spree::ShippingMethod.find_by_name!("Service")
service.calculator.preferences = {
    amount: 0
}
service.calculator.save!
service.save!
