Rails.application.routes.draw do
  root "homes#show"

  mount Symphonia::Engine => "/" # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resource :home do
    patch "scenario/:scenario", to: "homes#scenario", as: "scenario"
    delete "reset"
    # get "history.json", to: "homes#history"
    # get "somfy"
    # get "somfy/authorize", to: "homes#somfy_authorize"
  end

  # get "/up", to: proc { [200, {}, %w[ok]] }
  get "up" => "rails/health#show", as: :rails_health_check
end
