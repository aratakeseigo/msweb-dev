FactoryBot.define do

  # sb_clientモデルのテストデータsb_client_alarmboxを定義
  factory :sb_client do
    # status_id { 1 }
    # area_id { 1 }
    #sb_tanto_id { 1 }
    name { "アラームボックス" }
    daihyo_name { "テスト太郎" }
    prefecture_code { 13 }
    tel { "00000000000" }
    created_by { 1 }
    updated_by { 1 }
    # created_at { "2021/06/01 20:55:57" }
    # channel_id { 1 }
    #sb_agent_id { 1 }
    association :entity
    # association :sb_agent
    # association :sb_client_user
  end
end
