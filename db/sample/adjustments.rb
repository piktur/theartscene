Spree::Sample.load("orders")

first_order = Spree::Order.find_by!(number: '111')
last_order  = Spree::Order.find_by!(number: '112')

first_order.adjustments.create!(
  :amount => 0,
  :source => Spree::TaxRate.find_by!(name: 'GST'),
  :order  => first_order,
  :label => "Tax",
  :state => "open",
  :mandatory => true)

last_order.adjustments.create!(
  :amount => 0,
  :source => Spree::TaxRate.find_by_name!("GST"),
  :order  => last_order,
  :label => "Tax",
  :state => "open",
  :mandatory => true)
