Rails.application.routes.draw do
  resources :passwords
  devise_for :users, :controllers => { registrations: 'registrations' }
  root 'static#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
