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
  namespace :clients do
    get "/", action: "list"
    get "/list", action: "list"
    get "/search", action: "search"
    namespace :registration do
      get "/", action: "index", as: "index"
      post "/upload", action: "upload"
      post "/create", action: "create"
    end
    namespace :registration_exams do
      get "/:id/", action: "index", as: "index"
      post "/:id/upload", action: "upload", as: "upload"
      post "/:id/create", action: "create", as: "create"
    end
  end

  namespace :identify_company do
    get "/", action: "index"
    post "/update", action: "update"
    get "/new_entity", action: "new_entity"
    post "/create_entity", action: "create_entity"
  end

end
