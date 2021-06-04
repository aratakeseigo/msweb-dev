class SbClient < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture, primary_key: "code", foreign_key: "prefecture_code"
  belongs_to_active_hash :area
  belongs_to_active_hash :industry
  belongs_to_active_hash :channel

  belongs_to :sb_tanto, optional: true, class_name: "InternalUser", foreign_key: "sb_tanto_id"
  has_many :sb_client_users
  belongs_to :entity, optional: true
  belongs_to :sb_agent, optional: true

  validates :name, presence: true, length: { maximum: 255 }
  validates :daihyo_name, presence: true, length: { maximum: 255 }
  validates :zip_code, allow_blank: true, zip_code: true
  validates :prefecture, allow_blank: true, inclusion: { in: Prefecture.all, message: :inclusion_prefecture_code }
  validates :address, allow_blank: true, length: { maximum: 255 }
  validates :tel, allow_blank: true, tel: true
  validates :industry, allow_blank: true, inclusion: { in: Industry.all, message: :not_in_master }
  validates :channel, allow_blank: true, inclusion: { in: Channel.all, message: :not_in_master }
  validates :sb_agent, allow_blank: true, inclusion: { in: SbAgent.all, message: :not_in_master }
  validates :established_in, allow_blank: true, yyyymm: true
end
