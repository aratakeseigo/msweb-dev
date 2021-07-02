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
    get "/:id/exam", controller: "exam", action: "edit", as: "edit"
    get "/:id/exam/approve", controller: "exam", action: "edit_approve", as: "edit_approve"
    post "/:id/exam/update", controller: "exam", action: "update", as: "update"
    post "/:id/exam/apply", controller: "exam", action: "apply", as: "apply"
    get "/:id/exam/download", controller: "exam", action: "download", as: "download"
    post "/:id/exam/delete_file", controller: "exam", action: "delete_file"
  end

  namespace :identify_company do
    get "/", action: "index"
    post "/update", action: "update"
    get "/new_entity", action: "new_entity"
    post "/create_entity", action: "create_entity"
  end

  namespace :exams do
    get "/", action: "list"
    get "/list", action: "list"
  end
end
