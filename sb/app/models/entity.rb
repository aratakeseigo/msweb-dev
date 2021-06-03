class Entity < ActiveRecord::Base
  # 履歴は別テーブルの予定なので、profileは単体
  has_one :entity_profile
  accepts_nested_attributes_for :entity_profile
end
