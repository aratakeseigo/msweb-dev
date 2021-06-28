FactoryBot.define do
  factory :sb_guarantee_client, class: SbGuaranteeClient do
    transient do
      client { create :sb_client }
      entity { create :entity }
      internal_user { build :internal_user, name: "SB担当者１太郎", email: "sb_guarantee_client_1@example.com" }
    end
    sb_client_id { client.id }
    sequence(:company_name) { |n| Utils::CompanyNameUtils.to_zenkaku_name "エンティティ#{n}株式会社" }
    entity_id { entity.id }
    created_user { internal_user }
    updated_user { internal_user }
  end
end