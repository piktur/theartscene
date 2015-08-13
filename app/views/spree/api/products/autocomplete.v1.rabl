object @product

cache [I18n.locale, root_object]

attributes :name, :value

child @autocomplete_terms => :products do
  attributes :name, :value
end