FactoryBot.define do
  factory :sb_guarantee_exam do
    transient do
      internal_user { create :internal_user }
    end
    sequence(:exam_search_key) { |n| "EXAM-KEY#{n}" } # 審査検索キー
    status { Status::GuaranteeStatus::READY_FOR_CONFIRM }
    accepted_at { Time.zone.now } # 保証依頼日
    company_name { "株式会社ワークフィールド" } # 法人名
    daihyo_name { "臼倉　宏昌" } # 代表者名
    guarantee_start_at { "44256" } # 保証開始日
    guarantee_end_at { "44323" } # 保証終了日
    guarantee_amount { "1100000" } # 保証依頼額
    sb_guarantee_exam_id { "" } # 保証審査ID
    sb_client_id { "" } # クライアントID
    sb_guarantee_client_id { "" } # 保証元ID
    sb_guarantee_customer_id { "" } # 保証先ID
    sb_guarantee_request_id { "" } # 保証依頼ID
    created_by { "" } # 作成者ID
    updated_by { "" } # 更新者ID

    trait :approved do
      # transient do
      #   sb_approval { create :sb_approval_guarantee_exam }
      # end
      status { Status::ExamStatus::APPROVED }
      sb_approval { create :sb_approval_guarantee_exam }
    end
  end
end
