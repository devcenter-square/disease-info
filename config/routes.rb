Rails.application.routes.draw do
  #match '/diseases/index' => 'diseases#index', :as => :root, via: [:get, :post]
  root :to => 'diseases#index'
  resources :diseases, except: [:index], param: :disease
end
