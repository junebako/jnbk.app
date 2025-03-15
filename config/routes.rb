Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  get "/nikki/:date", to: "nikki#show", as: :nikki, constraints: { date: /\d{4}-\d{2}-\d{2}/ }

  root "root#show"
end
