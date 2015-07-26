Spree::Sample.load_sample("products")

volume = Spree::OptionType.find_by_presentation!("Volume")

wnaoc_tiwh = Spree::Product.find_by_name!("Winsor & Newton Artists' Oil Colours Titanium White")
wnaoc_tiwh.option_types = [volume]
wnaoc_tiwh.save!

wnaoc_wigy = Spree::Product.find_by_name!("Winsor & Newton Artists' Oil Colours Winsor Green (Yellow Shade)")
wnaoc_wigy.option_types = [volume]
wnaoc_wigy.save!
