Spree::Product.class_eval do
  include Elasticsearch::Model::Callbacks
end
