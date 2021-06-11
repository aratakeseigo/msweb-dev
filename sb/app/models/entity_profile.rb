# 企業概要テーブル
class EntityProfile < ActiveRecord::Base
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :entity
  belongs_to_active_hash :prefecture, primary_key: "code", foreign_key: "prefecture_code"

  def corporation_name=(corporation_name)
    write_attribute(:corporation_name, Utils::CompanyNameUtils.to_zenkaku_name(corporation_name))
    self.corporation_name_short = Utils::CompanyNameUtils.to_short_name(corporation_name)
    self.corporation_name_compare = Utils::CompanyNameUtils.to_compare_name(corporation_name)
  end
end
