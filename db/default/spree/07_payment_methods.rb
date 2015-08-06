bogus = Spree::Gateway::Bogus.find_or_create_by!(
  name:         'Credit Card',
  description:  'Bogus payment gateway',
  active:       true
)

check = Spree::PaymentMethod::Check.find_or_create_by!(
  name:         'Check',
  description:  'Pay by check',
  active:       true
)

Spree::Store.all.each do |store|
  Spree::StorePaymentMethod.create!(
      store: store,
      payment_method: bogus
  )

  Spree::StorePaymentMethod.create!(
      store: store,
      payment_method: check
  )
end