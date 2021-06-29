FactoryBot.define do
  factory :sb_client_exam, class: SbClientExam do
    transient do
      sb_client {build :sb_client, :client_exam_form}
      internal_user { build :internal_user, email: "sb_client_exam1@example.com" }
    end
    sb_client_id { sb_client.id }
    reject_reason { "否決理理由" }
    anti_social { true }
    anti_social_memo { "反社メモ" }
    tsr_score { "55" }
    tdb_score { "66" }
    communicate_memo { "社内連絡メモ" }
    available_flag { true }
    created_user { internal_user }
    updated_user { internal_user }
  end

  trait :available_flag_false do
    available_flag { false }
  end
  
  trait :has_approval_apply do
    
  end

  trait :has_approval_approved do
    
  end

  trait :has_approval_withdrawed do
    
  end

  trait :has_approval_remand do
    
  end

end