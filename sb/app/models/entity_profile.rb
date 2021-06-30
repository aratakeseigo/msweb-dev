# 企業概要テーブル
class EntityProfile < ActiveRecord::Base
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :entity
  belongs_to_active_hash :prefecture, primary_key: "code", foreign_key: "prefecture_code"

  def corporation_name=(corporation_name)
    if corporation_name.blank?
      write_attribute(:corporation_name, corporation_name)
      self.corporation_name_short = corporation_name
      self.corporation_name_compare = corporation_name
      return
    end
    write_attribute(:corporation_name, Utils::CompanyNameUtils.to_zenkaku_name(corporation_name))
    self.corporation_name_short = Utils::CompanyNameUtils.to_short_name(corporation_name)
    self.corporation_name_compare = Utils::CompanyNameUtils.to_compare_name(corporation_name)
  end

  def daihyo_name=(daihyo_name)
    if daihyo_name.blank?
      write_attribute(:daihyo_name, daihyo_name)
      return
    end
    write_attribute(:daihyo_name, Utils::StringUtils.to_zenkaku(daihyo_name))
  end

  def address=(address)
    if address.blank?
      write_attribute(:address, address)
      return
    end
    write_attribute(:address, Utils::StringUtils.to_zenkaku(address))
  end
end
