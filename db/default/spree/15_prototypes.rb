prototypes = [
  {
    :name => "Paint",
    :properties => ["Manufacturer", "Brand", "Manufacter Code", "Colour", "Description", "Pigments"]
  },
  {
    :name => "Workshop",
    :properties => ["Date", "Tutor", "Title", "Location", "Skill Level"]
  }
]

prototypes.each do |prototype_attrs|
  prototype = Spree::Prototype.create!(:name => prototype_attrs[:name])
  prototype_attrs[:properties].each do |property|
    prototype.properties << Spree::Property.where(name: property).first
  end
end
