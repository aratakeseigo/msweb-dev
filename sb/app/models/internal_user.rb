class InternalUser < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :sb_user_permission, optional: true, foreign_key: "id", primary_key: "internal_user_id"

  def is_sb_user?
    sb_user_permission.present? and sb_user_permission.available
  end

  # 決裁可能金額
  def approvable_amount
    sb_user_permission.sb_user_position&.approvable_amount || 0
  end

  #
  # 役職がXXX以上か
  # ex) マネージャー以上か
  #     is_position_upper_than_or_equal?(SbUserPosition::MANAGER)
  #
  def is_position_upper_than_or_equal?(base_position)
    sb_user_permission.sb_user_position.is_upper_than_or_equal(base_position)
  end
end
