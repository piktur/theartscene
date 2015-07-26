Spree::Sample.load_sample("addresses")

orders = []
orders << Spree::Order.create!(
  :number => "111",
  :email => "spree@example.com",
  :shipping_address => Spree::Address.first,
  :billing_address => Spree::Address.last)

orders << Spree::Order.create!(
  :number => "112",
  :email => "spree@example.com",
  :shipping_address => Spree::Address.first,
  :billing_address => Spree::Address.last)

orders[0].line_items.create!(
  :variant => Spree::Product.find_by_name!("Winsor & Newton Artists' Oil Colours Titanium White").master,
  :quantity => 1)

orders[1].line_items.create!(
  :variant => Spree::Product.find_by_name!("Winsor & Newton Artists' Oil Colours Winsor Green (Yellow Shade)").master,
  :quantity => 1)

orders.each(&:create_proposed_shipments)

orders.first do |order|
  order.state = "complete"
  order.completed_at = Time.now - 1.day
  order.save!
end
