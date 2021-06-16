FactoryBot.define do
  factory :sb_user_permission do
    transient do
      internal_user { create :internal_user }
    end
    internal_user_id { internal_user.id }
    sb_user_position { SbUserPosition::STAFF }
  end
end
