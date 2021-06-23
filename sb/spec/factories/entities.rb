FactoryBot.define do
  factory :entity do
    sequence(:house_company_code) { |n| "KG#{sprintf("%09d", n)}" }
    sequence(:corporation_number) { |n| "77#{sprintf("%011d", n)}" }
    show_flag { 1 }
    after(:build) do |entity|
      entity.entity_profile = FactoryBot.build(:entity_profile)
    end
  end
  factory :entity_profile do
    sequence(:corporation_name) { |n| Utils::CompanyNameUtils.to_zenkaku_name "エンティティ#{n}株式会社" }
    sequence(:corporation_name_short) { |n| Utils::CompanyNameUtils.to_short_name "エンティティ#{n}株式会社" }
    # corporation_name_compare { }
    sequence(:zip_code) { |n| "123#{sprintf("%04d", n)}" }
    sequence(:prefecture_code) { 1 }
    sequence(:address) { |n| Utils::StringUtils.to_zenkaku "エンティティ住所１－２－#{n}" }
    sequence(:daihyo_name) { |n| Utils::StringUtils.to_zenkaku "エンティティ　代表者#{n}" }
  end
end
