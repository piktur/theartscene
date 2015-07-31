Spree::TaxCategory.create!(:name => 'Goods')
Spree::TaxCategory.create!(:name => 'Services')

australia = Spree::Zone.find_or_create_by!(name: 'Australia')
goods     = Spree::TaxCategory.find_by!(name: 'Goods')

tax_rate  = Spree::TaxRate.create!(
    name:         'GST',
    zone:         australia,
    amount:       0.1,
    tax_category: goods
)

tax_rate.calculator = Spree::Calculator::DefaultTax.create!
tax_rate.save!
