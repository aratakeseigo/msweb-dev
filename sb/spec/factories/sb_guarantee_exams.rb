FactoryBot.define do
  factory :sb_guarantee_exam do
    transient do
      internal_user { create :internal_user }
    end
    status { Status::ExamStatus::READY_FOR_EXAM }
    accepted_at { Time.zone.now }
    transaction_contents { "取扱い商品" } # 取扱い商品
    payment_method_id { PaymentMethod.all.sample } # 決済条件
    payment_method_optional { "決済条件補足" } # 決済条件補足
    new_transaction { true } # 取引
    transaction_years { 3 } # 取引歴
    payment_delayed { true } # 支払い遅延
    payment_delayed_memo { "支払い遅延の状況" } # 支払い遅延の状況
    payment_method_changed { true } # 支払条件変更
    payment_method_changed_memo { "支払条件変更内容" } # 支払条件変更内容
    other_companies_ammount { 900000 } # 保証会社名
    other_guarantee_companies { "ＡＢ蛇内保証会社" } # 保証額
    guarantee_amount_hope { 5000000 } # 保証希望額
    sequence(:exam_search_key) { |n| "EXAM-KEY#{n}" } # 審査検索キー
    sb_guarantee_client
    sb_guarantee_customer
    sb_guarantee_exam_request
    sb_client
    created_user { internal_user }
    updated_user { internal_user }

    trait :approved do
      # transient do
      #   sb_approval { create :sb_approval_guarantee_exam }
      # end
      status { Status::ExamStatus::APPROVED }
      sb_approval { create :sb_approval_guarantee_exam }
    end
  end
end
