Rails.application.routes.draw do

  root "homes#show"

  mount Symphonia::Engine => '/'  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resource :home do
    get "somfy"
    get "somfy/authorize", to: "homes#somfy_authorize"
  end
end
