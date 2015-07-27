volume  = Spree::OptionType.find_or_create_by!(name: 'Volume', presentation: 'Volume')
colour  = Spree::OptionType.find_or_create_by!(name: 'Colour', presentation: 'Colour')
extras  = Spree::OptionType.find_or_create_by!(name: 'Extras', presentation: 'Extras')

Spree::OptionValue.create!([
  {
    :name => "37",
    :presentation => "37mL",
    :position => 1,
    :option_type => volume
  },
  {
    :name => "150",
    :presentation => "150mL",
    :position => 2,
    :option_type => volume
  },
  {
    :name => "200",
    :presentation => "200mL",
    :position => 3,
    :option_type => volume
  },
  {
    :name => "500",
    :presentation => "500mL",
    :position => 4,
    :option_type => volume
  },
  {
    :name => "Red",
    :presentation => "Red",
    :position => 1,
    :option_type => colour
  },
  {
    :name => "Blue",
    :presentation => "Blue",
    :position => 2,
    :option_type => colour
  },
  {
    :name => "Accommodation",
    :presentation => "Accommodation",
    :position => 1,
    :option_type => extras
  }
])
