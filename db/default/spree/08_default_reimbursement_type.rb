csv = SmarterCSV.process(
    File.join(Rails.root, 'db', 'default', 'data', '_ReturnReasons.csv')
)

csv.each do |item|
  Spree::RefundReason.find_or_create_by(
    {
      name: item[:name],
      active: item[:active],
      mutable: item[:mutable]
    }
  )
end
