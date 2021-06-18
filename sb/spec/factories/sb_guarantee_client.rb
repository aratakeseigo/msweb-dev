FactoryBot.define do
  factory :sb_guarantee_client do
    transient do
      user { create :internal_user }
    end
    company_name { "アラームボックス株式会社" }
    daihyo_name { "山田　太郎" }
    tel { "11111111111" }
    prefecture { Prefecture.all.sample }
    address { "中央区日本橋小伝馬町５－３－５" }
    taxagency_corporate_number { "1112223334445" }
    created_user { user }
    updated_user { user }
    sb_client
    entity

    trait :other_client do
      company_name { "セキュアボックス株式会社" }
      daihyo_name { "鈴木　一郎" }
      tel { "22222222222" }
      address { "川崎市高津区北見方５－３－５" }
      taxagency_corporate_number { "4445556667778" }
    end
  end
end
