FactoryBot.define do
  factory :sb_client, class: SbClient do
    transient do
      entity { build :entity }
      sb_agent { create :sb_agent }
      internal_user { create :internal_user }
    end
    entity_id { entity.id }
    status_id { 1 }
    area_id { 1 }
    sb_tanto { internal_user }
    name { "アラームボックス" }
    daihyo_name { "テスト　太郎" }
    prefecture_code { 13 }
    tel { "00000000000" }
    created_at { "2021/06/01 20:55:57" }
    channel_id { 1 }
    created_user { internal_user }
    updated_user { internal_user }

    trait :has_no_agent do
      transient do
        entity { build :entity }
        sb_agent { create :sb_agent }
        internal_user { create :internal_user, name: "SB担当者１太郎", email: "sb_client_1@example.com" }
      end
      daihyo_name { "武田　浩和" }
      prefecture_code { 13 }
      sb_tanto { internal_user }
      created_user { internal_user }
      updated_user { internal_user }
      after(:build) do |sb_client|
        sb_client.sb_client_users = []
        sb_client.sb_client_users << build(:sb_client_user)
      end
    end

    trait :has_agent do
      transient do
        internal_user2 { create :internal_user, name: "SB担当者２次郎", email: "sb_client_2@example.com" }
      end
      status_id { 2 }
      area_id { 2 }
      sb_tanto { internal_user2 }
      name { "東沖縄電力株式会社" }
      daihyo_name { "東風平　太郎" }
      prefecture_code { 47 }
      tel { "11111111111" }
      created_at { "2021/06/02 20:55:57" }
      channel_id { 2 }
      sb_agent_id { sb_agent.id }
      created_user { internal_user2 }
      updated_user { internal_user2 }
      after(:build) do |sb_client_2|
        sb_client_2.sb_client_users = []
        sb_client_2.sb_client_users << build(:sb_client_user, name: "横浜　三郎", contact_tel: "44444444444")
      end
    end

    trait :escape_sequence do
      transient do
        internal_user3 { create :internal_user, name: "SB担当者３次郎", email: "sb_client_3@example.com" }
      end
      status_id { 3 }
      area_id { 3 }
      sb_tanto { internal_user3 }
      name { "アラーム\'\%ボックス" }
      daihyo_name { "特殊　文字" }
      prefecture_code { 33 }
      tel { "33333333333" }
      created_at { "2021/06/03 20:55:57" }
      channel_id { 3 }
      created_user { internal_user3 }
      updated_user { internal_user3 }
      after(:build) do |sb_client_3|
        sb_client_3.sb_client_users = []
        sb_client_3.sb_client_users << build(:sb_client_user, name: "徳川　家康", contact_tel: "55555555555")
      end
    end
  end
end
