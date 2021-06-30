FactoryBot.define do
  factory :sb_approval, class: SbApproval do
    transient do
      internal_user { create :internal_user }
    end
    status_id { Status::SbApproval::APPLYING[:id] }
    applied_user { internal_user }
    created_user { internal_user }
    updated_user { internal_user }
    trait :sb_exam_approval do
      type { "SbApproval::ClientExam" }
      relation_id { nil }
    end
  end
end