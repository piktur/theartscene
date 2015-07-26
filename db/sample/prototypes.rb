prototypes = [
  {
    :name => "Paint",
    :properties => ["Manufacturer", "Brand", "Manufacter Code", "Colour", "Description", "Pigments"]
  }
]

prototypes.each do |prototype_attrs|
  prototype = Spree::Prototype.create!(:name => prototype_attrs[:name])
  prototype_attrs[:properties].each do |property|
    prototype.properties << Spree::Property.where(name: property).first
  end
end
