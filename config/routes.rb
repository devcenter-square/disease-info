Rails.application.routes.draw do
  resources :diseases, param: :disease
end
