colour  = Spree::OptionType.find_or_create_by!(name: 'Colour', presentation: 'Colour')
extras  = Spree::OptionType.find_or_create_by!(name: 'Extras', presentation: 'Extras')

Spree::OptionValue.create!([
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
