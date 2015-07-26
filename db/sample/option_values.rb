Spree::Sample.load_sample("option_types")

volume  = Spree::OptionType.find_by_presentation!('Volume')

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
  }
])
