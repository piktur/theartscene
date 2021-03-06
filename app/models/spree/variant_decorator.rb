# spree_price_books-ff06cba70d07/app/models/spree/variant_decorator.rb
Spree::Variant.class_eval do

  ## Associations

  has_one :default_price,
    -> { where currency: Spree::Config[:currency], price_book_id: Spree::PriceBook.default.id },
    class_name: 'Spree::Price',
    dependent: :destroy

  has_many :price_books, -> { active.order('spree_prices.amount ASC, spree_price_books.priority DESC') }, through: :prices

  has_many :prices,
    class_name: 'Spree::Price',
    dependent: :destroy,
    inverse_of: :variant

  ## Class Methods

  ## Instance Methods

  def display_list_price(currency = Spree::Config[:currency], store_id = Spree::Store.default.id, role_ids = nil)
    lp = list_price_in(currency, store_id)
    raise RuntimeError, "No available price for Variant #{id} with #{currency} currency in store #{store_id}." unless lp
    Spree::Money.new lp.amount, currency: lp.currency
  end

  def list_price_in(currency = Spree::Config[:currency], store_id = Spree::Store.default.id, role_ids = nil)
    if store_id
      price.list.by_currency(currency).by_store(store_id).by_role(role_ids).first
    else
      price.list.by_currency(currency).by_role(role_ids).first
    end
  end

  # TODO nasty hack for demo refer to originak
  def price_in(currency = Spree::Config[:currency], store_id = Spree::Store.default.id, role_ids = 1)
    if store_id
      price #.by_currency('AUD').by_store(1).by_role(1).first
    else
      price #.by_currency('AUD').by_role(1).first
    end
  end

end
