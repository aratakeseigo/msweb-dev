FactoryBot.define do
  factory :identify_company_sb_client1, class: SbClient do
    transient do
      entity { build :entity }
      sb_agent { create :sb_agent }
      internal_user { create :internal_user, name: "SB担当者１太郎", email: "sb_client_1@example.com" }
    end

    id { 1 }
    entity_id { nil }
    status_id { 1 }
    taxagency_corporate_number { 1111111111111 }
    name { "未特定企業１"}
    daihyo_name { "企業未特定　太郎１" }
    created_at { "2021/06/01 12:00:00" }
    updated_at { "2021/06/01 12:00:00" }
    created_user { internal_user }
    updated_user { internal_user }

  end

  factory :identify_company_sb_client2, class: SbClient do
    transient do
      entity { build :entity }
      sb_agent { create :sb_agent }
      internal_user { create :internal_user, id: "11111", name: "SB担当者１太郎", email: "sb_client_1@example.com" }
    end

    id { 2 }
    entity_id { nil }
    status_id { 1 }
    taxagency_corporate_number { 2222222222222 }
    name { "未特定企業２"}
    daihyo_name { "企業未特定　太郎２" }
    created_at { "2021/06/01 12:00:00" }
    updated_at { "2021/06/01 12:00:00" }
    created_user { internal_user }
    updated_user { internal_user }
  end

  factory :identify_company_sb_client3, class: SbClient do
    transient do
      entity { build :entity }
      sb_agent { create :sb_agent }
      internal_user { create :internal_user, name: "SB担当者１太郎", email: "sb_client_1@example.com" }
    end

    id { 3 }
    entity_id { nil }
    status_id { 1 }
    taxagency_corporate_number { 3333333333333 }
    name { "未特定企業３"}
    daihyo_name { "企業未特定　太郎３" }
    created_at { "2021/06/01 12:00:00" }
    updated_at { "2021/06/01 12:00:00" }
    created_user { internal_user }
    updated_user { internal_user }
  end

  factory :identify_company_sb_client4, class: SbClient do
    transient do
      entity { build :entity }
      sb_agent { create :sb_agent }
      internal_user { create :internal_user, name: "SB担当者１太郎", email: "sb_client_1@example.com" }
    end

    id { 4 }
    entity_id { nil }
    status_id { 1 }
    taxagency_corporate_number { 4444444444444 }
    name { "未特定企業４"}
    daihyo_name { "企業未特定　太郎４" }
    created_at { "2021/06/01 12:00:00" }
    updated_at { "2021/06/01 12:00:00" }
    created_user { internal_user }
    updated_user { internal_user }
  end

  factory :identify_company , class: "IdentifyCompanyForm" do
    classification { "1" }
    id {"1"}
    company_name {"未特定企業５"}
    daihyo_name { "企業未特定　太郎５" }
    zip_code {"1112222"}
    prefecture_code {"13"}
    address { "東京都新宿区１－１－１" }
    tel { "11111111111" }
    established { "200004" }
    taxagency_corporate_number { 4444444444444 }
  end

  factory :identify_company_entity1, class: Entity do
    id { 1111}
    corporation_number { 1111111111111 }
    created_at { "2021/06/01 12:00:00" }
    after(:build) do |entity|
      entity.entity_profile = FactoryBot.build(:identify_company_entity_profile1)
    end
  end
  factory :identify_company_entity_profile1, class: EntityProfile  do
    entity_id { 1111 }
  end

  factory :identify_company_entity2, class: Entity do
    id { 2222 }
    created_at { "2021/06/01 12:00:00" }
    after(:build) do |entity|
      entity.entity_profile = FactoryBot.build(:identify_company_entity_profile2)
    end
  end
  factory :identify_company_entity_profile2, class: EntityProfile  do
    entity_id { 2222 }
    corporation_name { "未特定企業２" }
  end

  factory :identify_company_entity3, class: Entity do
    id { 3333 }
    created_at { "2021/06/01 12:00:00" }
    after(:build) do |entity|
      entity.entity_profile = FactoryBot.build(:identify_company_entity_profile3)
    end
  end
  factory :identify_company_entity_profile3, class: EntityProfile  do
    entity_id { 3333 }
    daihyo_name { "企業未特定　太郎３" }
  end

  factory :identify_company_entity4, class: Entity do
    id { 4444 }
    created_at { "2021/06/01 12:00:00" }
    after(:build) do |entity|
      entity.entity_profile = FactoryBot.build(:identify_company_entity_profile4)
    end
  end
  factory :identify_company_entity_profile4, class: EntityProfile  do
    entity_id { 4444 }
    daihyo_name { "企業未特定　太郎４" }
  end

  factory :identify_company_form, class: IdentifyCompanyForm do
    classification { "1" }
    id { "1" }
    company_name { "株式会社〇〇〇" }
    daihyo_name { "苗字　名前" }
    taxagency_corporate_number { "2222222222222" }
    prefecture_code { "13" }
    address { "東京都新宿区１－１－１" }
    daihyo_tel { "0311112222" }
    established { "200001" }
    zip_code { "1234567" }
    path { "/clients/list" }

  end

end
