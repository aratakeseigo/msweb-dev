FactoryBot.define do
  factory :internal_user_no_sb, class: InternalUser do
    sequence(:login_id) { |n| "test#{n}" }
    name { "海老　能見" }
    sequence(:email) { |n| "ab_only-#{n}@example.com" }
    password { "password" }
  end
  factory :internal_user do
    sequence(:login_id) { |n| "test#{n}" }
    name { "吉田　一雄" }
    sequence(:email) { |n| "test-#{n}@example.com" }
    password { "password" }

    after(:create) do |user|
      FactoryBot.create(:sb_user_permission, internal_user_id: user.id)
    end

    trait :manager do
      name { "真似　時也" }
      sequence(:email) { |n| "manager-#{n}@example.com" }
      password { "password" }
      after(:create) do |user|
        FactoryBot.create(:sb_user_permission, internal_user_id: user.id, sb_user_position: SbUserPosition::MANAGER)
      end
    end
  end
end
