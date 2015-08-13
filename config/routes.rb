Rails.application.routes.draw do

  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Spree relies on it being the default of "spree"
  mount Spree::Core::Engine, :at => '/'
end

# To ensure correct route precedence, list similar routes first
# ie. 'products/autocomplete' would call 'products/show' with id
Spree::Core::Engine.routes.draw do
  # root to: 'home#index'
  get '/search',                 to: 'home#search', as: :search

  get '/help',                   to: 'help#index'
  get '/about',                  to: 'about#index'
  get '/mitchell-school-of-art', to: 'msa#index', as: :msa
  
  get 'products/latest',         to: 'products#latest', via: :get, as: :latest
  get 'products/autocomplete',   to: 'products#autocomplete', via: :get, as: :autocomplete, format: 'json'


  # resources :products, :only => [:index, :show, :autocomplete] do
  #   collection do
  #     match :autocomplete, to: 'products#autocomplete', via: :get, format: 'json'
  #   end
  # end

  namespace :api, defaults: { format: 'json' } do
    get 'products/autocomplete', to: 'products#autocomplete', as: :products_autocomplete
    resources :products do
      get 'autocomplete'
    end
  end
end

Spree::Core::Engine.routes.append do
  namespace :admin do
    resources :xero_session do
      collection do
        get :contacts
        get :invoices
      end
    end

    resources :reports, only: [:index] do
      collection do
        get :new_users_by_date
        get :products_by_category
        # post :sales_total
      end
    end
  end
end