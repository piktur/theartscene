# Convert raw data to Hash for processing
csv = SmarterCSV.process(
    File.join(Rails.root, 'db', 'default', 'data', '_OptionValues.csv')
)

csv.each do |item|
  Spree::OptionValue.find_or_create_by!(
    {
      name:         item[:name],
      presentation: item[:presentation],
      position:     item[:position],
      option_type_id: Spree::OptionType.find_by!(name: item[:option_type])
    }
  )
end

# colour  = Spree::OptionType.find_or_create_by!(name: 'Colour', presentation: 'Colour')
# extras  = Spree::OptionType.find_or_create_by!(name: 'Extras', presentation: 'Extras')
#
# Spree::OptionValue.create!([
#   {
#     :name => "Red",
#     :presentation => "Red",
#     :position => 1,
#     :option_type => colour
#   },
#
#   {
#     :name => "Blue",
#     :presentation => "Blue",
#     :position => 2,
#     :option_type => colour
#   },
#
#   {
#     :name => "Accommodation",
#     :presentation => "Accommodation",
#     :position => 1,
#     :option_type => extras
#   }
# ])