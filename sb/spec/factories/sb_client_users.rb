FactoryBot.define do
  factory :sb_client_user, class: SbClientUser do
    id { 1 }
    name { "テストSBユーザー" }
    contact_tel {11111111111}
  end
end