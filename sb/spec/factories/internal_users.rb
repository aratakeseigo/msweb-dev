FactoryBot.define do
  factory :internal_user do
    id { 1 }
    name { "テストSB担当者" }
    email { "test@example.com" }
    password { "password" }
  end
end
