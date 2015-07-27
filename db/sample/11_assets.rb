products = {}
products[:wnaoc_tiwh] = Spree::Product.find_by!(name: "Winsor & Newton Artists' Oil Colours Titanium White 37mL")
products[:wnaoc_wigy] = Spree::Product.find_by!(name: "Winsor & Newton Artists' Oil Colours Winsor Green (Yellow Shade) 37mL")

def image(name, type="jpg")
  images_path = File.join(File.dirname(__FILE__), 'images')
  path = File.join(images_path, "#{name}.#{type}")
  return false if !File.exist?(path)
  File.open(path)
end

images = {
  products[:wnaoc_tiwh].master => [
    {
      :attachment => image("wnaoc_tiwh")
    }
  ],

  products[:wnaoc_wigy].master => [
    {
        :attachment => image("wnaoc_wigy")
    }
  ]
}

# # products[:wnaoc_tiwh].variants.each do |variant|
# #   variant.images.create!(:attachment => image("wnaoc_tiwh"))
# #   variant.images.create!(:attachment => image("wnaoc_tiwh_swatch"))
# # end
# #
# # products[:wnaoc_wigy].variants.each do |variant|
# #   variant.images.create!(:attachment => image("wnaoc_wigy"))
# #   variant.images.create!(:attachment => image("wnaoc_wigy_swatch"))
# # end

images.each do |variant, attachments|
  attachments.each do |attachment|
    variant.images.create!(attachment)
  end
end

