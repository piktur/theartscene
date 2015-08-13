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
# == Generate CSV from master.xlsx worksheets
# Roo will convert the spreadsheet to Ruby Objects
# We then generate csv files from each worksheet
# TODO _master040815 has all data
xlsx = Roo::Excelx.new(File.join(data, '_master080815.xlsx'))

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

# Spree::Core::Engine.load_seed if defined?(Spree::Core)
Spree::Auth::Engine.load_seed if defined?(Spree::Auth)

Rake::Task['db:load_dir'].reenable
Rake::Task['db:load_dir'].invoke(factories)

