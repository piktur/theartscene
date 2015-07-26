Spree::Store.new do |s|
  s.code              = 'as'
  s.name              = 'The Art Scene'
  s.url               = 'artscene.com.au'
  s.mail_from_address = 'piktur.io@gmail.com'
end.save!

Spree::Store.new do |s|
  s.code              = 'aas'
  s.name              = 'Australian Art Supplies'
  s.url               = 'australianartsupplies.com.au'
  s.mail_from_address = 'piktur.io@gmail.com'
end.save!

Spree::Store.new do |s|
  s.code              = 'ab'
  s.name              = 'Art Basics'
  s.url               = 'artbasics.com.au'
  s.mail_from_address = 'piktur.io@gmail.com'
end.save!