# # Convert raw data to Hash for processing
# csv = SmarterCSV.process(
#     File.join(Rails.root, 'db', 'default', 'data', '_Prototypes.csv')
# )
#
# csv.each do |item|
#   puts item[:taxons].split(',')
# end
#   taxons = []
#
#   item[:taxons].split(',').each do |taxon|
#     Spree::Taxon.find_or_create_by!(
#
#   end
#       taxon[:presentation]
#   )
#   Spree::Prototype.find_or_create_by!(
#     {
#       name:         item[:name],
#       taxons: [
#
#       ],
#       option_types: item[:position],
#       properties:   Spree::OptionType.find_by!(name: item[:option_type])
#     }
#   )
# end
#
# prototypes = [
#     {
#         :name => "Paint",
#         :properties => ["Manufacturer", "Brand", "Manufacter Code", "Colour", "Description", "Pigments"]
#     },
#     {
#         :name => "Workshop",
#         :properties => ["Date", "Tutor", "Title", "Location", "Skill Level"]
#     }
# ]
#
# prototypes.each do |prototype_attrs|
#   prototype = Spree::Prototype.create!(:name => prototype_attrs[:name])
#   prototype_attrs[:properties].each do |property|
#     prototype.properties << Spree::Property.where(name: property).first
#   end
# end