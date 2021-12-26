Rails.application.routes.draw do

  root "homes#show"

  mount Symphonia::Engine => '/'  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resource :home do
    patch "scenario/:scenario", to: "homes#scenario", as: "scenario"
    get "somfy"
    get "somfy/authorize", to: "homes#somfy_authorize"
  end
end
