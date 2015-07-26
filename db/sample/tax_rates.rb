australia = Spree::Zone.find_by_name!('Australia')
goods     = Spree::TaxCategory.find_by_name!('Goods')
tax_rate  = Spree::TaxRate.create(
  :name         => 'GST',
  :zone         => australia,
  :amount       => 0.1,
  :tax_category => goods)
tax_rate.calculator = Spree::Calculator::DefaultTax.create!
tax_rate.save!
