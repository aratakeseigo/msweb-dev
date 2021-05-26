Rails.application.routes.draw do
  root to: "top#index"

  get "top/index"
  get "top/show"
  devise_for :internal_users, controllers: {
                                sessions: "internal_users/sessions",
                                confirmations: "internal_users/confirmations",
                                passwords: "internal_users/passwords",
                                registrations: "internal_users/registrations",
                                unlocks: "internal_users/unlocks",
                                omniauth: "internal_users/omniauth",
                              }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
