FactoryBot.define do
  factory :by_customer, class: ByCustomer do
    transient do
      entity { create :entity }
    end
    customer_name { "アラームボックス株式会社" }
    entity_id { entity.id }
  end
end