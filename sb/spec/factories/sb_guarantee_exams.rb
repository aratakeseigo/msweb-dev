FactoryBot.define do
  factory :sb_guarantee_exam do
    name { "山田　太郎" }
    name_kana { "ヤマダ　タロウ" }
    contact_tel { "11111111111" }
    sb_client
  end
end
