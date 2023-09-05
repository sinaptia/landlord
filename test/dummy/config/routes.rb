Rails.application.routes.draw do
  resources :tenants do
    resources :people
  end

  root to: "tenants#index"
end
