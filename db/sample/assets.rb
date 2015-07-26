Spree::Sample.load_sample("products")
Spree::Sample.load_sample("variants")

products = {}
products[:wnaoc_tiwh] = Spree::Product.find_by_name!("Winsor & Newton Artists' Oil Colours Titanium White")
products[:wnaoc_wigy] = Spree::Product.find_by_name!("Winsor & Newton Artists' Oil Colours Winsor Green (Yellow Shade)")


def image(name, type="jpg")
  images_path = Pathname.new(File.dirname(__FILE__)) + "images"
  path = images_path + "#{name}.#{type}"
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

products[:wnaoc_tiwh].variants.each do |variant|
  variant.images.create!(:attachment => image("wnaoc_tiwh", "jpg"))
  variant.images.create!(:attachment => image("wnaoc_tiwh_swatch", "jpg"))
end

products[:wnaoc_wigy].variants.each do |variant|
  variant.images.create!(:attachment => image("wnaoc_wigy", "jpg"))
  variant.images.create!(:attachment => image("wnaoc_wigy_swatch", "jpg"))
end


images.each do |variant, attachments|
  puts "Loading images for #{variant.product.name}"
  attachments.each do |attachment|
    variant.images.create!(attachment)
  end
end

