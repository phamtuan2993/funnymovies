Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post "sign_up", to: "users#create"
  post "sign_in", to: "sessions#create"

  resources :movies
end
