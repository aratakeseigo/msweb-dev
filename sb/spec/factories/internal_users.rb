FactoryBot.define do
  factory :internal_user do
    sequence(:login_id) { |n| "test#{n}" }
    name { "吉田　一雄" }
    email { "test@example.com" }
    password { "password" }
  end
end
