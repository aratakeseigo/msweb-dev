class SbUserPermission < ActiveRecord::Base
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :sb_user_position
  has_one :internal_user
end
