FactoryBot.define do
  factory :sb_client, class: SbClient do
    transient do
      entity { build :entity }
      sb_agent {build :sb_agent}
      internal_user { build :internal_user, name: "SB担当者１太郎", email: "sb_client_1@example.com" }
      internal_user2 { build :internal_user, name: "SB担当者２次郎", email: "sb_client_2@example.com" }
    end
    entity_id { entity.id }

    trait :has_no_agent do
      status_id { 1 }
      area_id { 1 }
      sb_tanto { internal_user }
      name { "アラームボックス" }
      daihyo_name { "武田　浩和" }
      prefecture_code { 13 }
      tel { "00000000000" }
      created_at { "2021/06/01 20:55:57" }
      channel_id { 1 }
      created_user { internal_user }
      updated_user { internal_user }
      after(:build) do |sb_client|
        sb_client.sb_client_users = []
        sb_client.sb_client_users << build(:sb_client_user)
      end
    end

    trait :has_agent do
      status_id { 2 }
      area_id { 2 }
      sb_tanto { internal_user2 }
      name { "東沖縄電力株式会社" }
      daihyo_name { "東風平　太郎" }
      prefecture_code { 47 }
      tel { "11111111111" }
      created_at { "2021/06/02 20:55:57" }
      channel_id { 2 }
      sb_agent { sb_agent }
      created_user { internal_user2 }
      updated_user { internal_user2 }
      after(:build) do |sb_client_2|
        puts sb_client_2
        sb_client_2.sb_client_users = []
        sb_client_2.sb_client_users << build(:sb_client_user, name: "横浜　三郎", contact_tel: "44444444444")
      end
    end
  end
end
