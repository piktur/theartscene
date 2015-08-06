# Convert raw data to Hash for processing
csv = SmarterCSV.process(
    File.join(Rails.root, 'db', 'default', 'data', '_OptionTypes.csv')
)

csv.each do |item|
  Spree::OptionType.find_or_create_by!(
      {
          name:         item[:name],
          presentation: item[:presentation],
          position:     1
      }
  )
end

# Spree::OptionType.create!([
#   {
#     :name => "colour",
#     :presentation => "Colour",
#     :position => 1
#   }
# ])
