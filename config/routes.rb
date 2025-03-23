require "sidekiq/web"
require "sidekiq/cron/web"

Rails.application.routes.draw do
  devise_for :users
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => "/admin/sidekiq"
  end
  root "homes#show"
  
  resource :home do
    patch "scenario/:scenario", to: "homes#scenario", as: "scenario"
    delete "reset"
    # get "history.json", to: "homes#history"
  end

  get "up" => "rails/health#show", :as => :rails_health_check
end
