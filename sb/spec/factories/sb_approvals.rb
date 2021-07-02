FactoryBot.define do
  factory :sb_approval_guarantee_exam, class: "SbApproval::GuaranteeExam" do
    transient do
      internal_user_apply { create :internal_user }
      sb_guarantee_exam { create :sb_guarantee_exam }
    end
    status { Status::SbApproval::APLYING } # "結果id(申請中:0 差し戻し:9 承認:1)"
    applied_user { internal_user_apply } # "申請者"
    applied_at { Time.zone.now } # "申請日時"
    apply_comment { "おねがいします" } # "申請時コメント"
    relation_id { sb_guarantee_exam.id } # "決裁対象ID(STI)"
    created_user { internal_user_apply } # "作成者"
    updated_user { internal_user_apply } # "更新者"

    trait :approved do
      transient do
        internal_user_approve { create :internal_user }
      end
      status { Status::SbApproval::APPROVED } # "結果id(申請中:0 差し戻し:9 承認:1)"
      approved_user { internal_user_approve } # "決裁者"
      approved_at { Time.zone.now } # "申請日時"
      approve_comment { "OKです" } # "決裁時コメント"
    end
  end
end
