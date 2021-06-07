FactoryBot.define do
  factory :internal_user, class: InternalUser do
    id { 1 }
    name { "テストSB担当者" }
  end
end