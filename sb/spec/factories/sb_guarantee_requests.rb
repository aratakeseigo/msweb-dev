FactoryBot.define do
  factory :sb_guarantee_request do
    transient do
      user { create :internal_user }
    end
    sb_client
    created_user { user }
    updated_user { user }
  end
end
