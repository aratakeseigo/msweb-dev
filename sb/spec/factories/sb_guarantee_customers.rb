FactoryBot.define do
  factory :sb_guarantee_customer, class: SbGuaranteeCustomer do
    transient do
      entity { create :entity }
      internal_user { build :internal_user, name: "SB担当者１太郎", email: "sb_guarantee_customer_1@example.com" }
      client { create :sb_client }
    end
    sb_guarantee_client_id { client.id }
    entity_id { entity.id }
    company_name { entity.entity_profile.corporation_name }
    created_user { internal_user }
    updated_user { internal_user }
  end
end