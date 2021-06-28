FactoryBot.define do
  factory :sb_guarantee_exam, class: SbGuaranteeExam do
    transient do
      client { build :sb_client }
      guarantee_client { build :sb_guarantee_client }
      guarantee_customer { build :sb_guarantee_customer, sb_guarantee_client_id: guarantee_client.id }
      internal_user { build :internal_user }
      today { Date.today }
    end
    accepted_at { today }
    sb_client { client }
    sb_guarantee_client { guarantee_client }
    sb_guarantee_customer_id { guarantee_customer }
    guarantee_amount_hope { 1000000 }
    created_user { internal_user }
    updated_user { internal_user }
  end
end