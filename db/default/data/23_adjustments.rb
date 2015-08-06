first = Spree::Order.find_by!(number: '111')
second = Spree::Order.find_by!(number: '112')
third = Spree::Order.find_by!(number: '113')

first.adjustments.create!(
  :amount => 0,
  :source => Spree::TaxRate.find_by!(name: 'GST'),
  :order  => first,
  :label => "Tax",
  :state => "open",
  :mandatory => true)

second.adjustments.create!(
    :amount => 0,
    :source => Spree::TaxRate.find_by!(name: 'GST'),
    :order  => second,
    :label => "Tax",
    :state => "open",
    :mandatory => true)

third.adjustments.create!(
  :amount => 0,
  :source => Spree::TaxRate.find_by!(name: 'GST'),
  :order  => third,
  :label => "Tax",
  :state => "open",
  :mandatory => true)
