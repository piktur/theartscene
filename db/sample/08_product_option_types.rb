# volume = Spree::OptionType.find_by!(name: "Volume")
extras = Spree::OptionType.find_by!(name: "Extras")
#
# wnaoc_tiwh = Spree::Product.find_by!(name: "Winsor & Newton Artists' Oil Colours Titanium White 37mL")
# wnaoc_tiwh.option_types = [volume]
# wnaoc_tiwh.save!
#
# wnaoc_wigy = Spree::Product.find_by!(name: "Winsor & Newton Artists' Oil Colours Winsor Green (Yellow Shade) 37mL")
# wnaoc_wigy.option_types = [volume]
# wnaoc_wigy.save!

msa_jz = Spree::Product.find_by!(name: "Josef Zbukvic Workshop at The Mitchell School of Art Summer 2016")
msa_jz.option_types = [extras]
msa_jz.save!

msa_hp = Spree::Product.find_by!(name: "Herman Pekel Workshop at The Mitchell School of Art Summer 2016")
msa_hp.option_types = [extras]
msa_hp.save!
