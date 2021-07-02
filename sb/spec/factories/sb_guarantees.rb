FactoryBot.define do
  factory :sb_guarantee do
    transient do
      internal_user { create :internal_user }
    end
    sequence(:exam_search_key) { |n| "EXAM-KEY#{n}" } # 審査検索キー
    status { Status::GuaranteeStatus::READY_FOR_CONFIRM }
    accepted_at { Time.zone.now } # 保証依頼日
    company_name { "株式会社ゴエモン商事" } # 法人名
    daihyo_name { "麺屋　七右衛門" } # 代表者名
    guarantee_start_at { "2021/07/02" } # 保証開始日
    guarantee_end_at { "2021/07/03" } # 保証終了日
    guarantee_amount_hope { "1100000" } # 保証依頼額
    guarantee_amount { "11100" } # 保証額

    sb_client
    sb_guarantee_client
    sb_guarantee_customer
    sb_guarantee_exam
    sb_guarantee_request
    created_user { internal_user }
    updated_user { internal_user }
  end
end
