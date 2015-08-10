Rails.application.routes.draw do

  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Spree relies on it being the default of "spree"
  mount Spree::Core::Engine, :at => '/'
end

Spree::Core::Engine.routes.append do
  #get '/about', :to => 'about#index', :as => :about

  namespace :admin do
    resources :xero_session do
      collection do
        get :contacts
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