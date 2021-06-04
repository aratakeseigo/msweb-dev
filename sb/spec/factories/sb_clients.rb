FactoryBot.define do

  # sb_clientモデルのテストデータsb_client_alarmboxを定義
  factory :sb_client_alarmbox, class: SbClient do
    name { 'アラームボックス' }
    daihyo_name { 'テスト太郎' }
    prefecture_code { 13 }
    address { '新宿区市谷本村町３−２２ ナカバビルヂング 8F' }
    association :entity
  end
end