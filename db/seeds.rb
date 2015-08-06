# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Spree::Core::Engine.load_seed if defined?(Spree::Core)
data      = File.join(Rails.root, 'db', 'default', 'data')
factories = File.join(Rails.root, 'db', 'default', 'spree')

# ===========================================================================

# Seed spreadsheet containing data for configurable Spree Objects,
# Object per Sheet
# Have Roo convert the spreadsheet to Ruby Objects and store it in memory
xlsx = Roo::Excelx.new(File.join(data, '_master040815.xlsx'))

# Convert each sheet to CSV and output to a single file per object
xlsx.sheets.each do |sheet|
  # Append date string for identification
  csv = File.join(data, "_#{sheet}.csv")

  File.open(csv, 'w+') do |csv|
    csv << xlsx.sheet(sheet).to_csv
    csv.close
  end
end
# ===========================================================================

Rake::Task['db:load_dir'].reenable
Rake::Task['db:load_dir'].invoke(factories)

# Spree::Core::Engine.load_seed if defined?(Spree::Core)
Spree::Auth::Engine.load_seed if defined?(Spree::Auth)