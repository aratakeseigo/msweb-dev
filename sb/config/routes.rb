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
    get "/:id/registration_exams", controller: "registration_exams", action: "index", as: "registration_exams_index"
    post "/:id/registration_exams/upload", controller: "registration_exams", action: "upload", as: "registration_exams_upload"
    post "/:id/registration_exams/create", controller: "registration_exams", action: "create", as: "registration_exams_create"
    namespace :exam do
      get "/:id", action: "edit", as: "edit"
      post "/:id/update", action: "update", as: "update"
      get "/:id/download", action: "download", as: "download"
      post "/:id/delete_file", action: "delete_file"
    end
  end
  namespace :exams do
    get "/", action: "list"
    get "/list", action: "list"
  end
end
