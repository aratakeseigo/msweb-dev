FactoryBot.define do
  factory :sb_agent do
    transient do
      entity { create :entity }
    end
    entity_id { entity.id }
    name { "テスト代理店" }
  end
end
