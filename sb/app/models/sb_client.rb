class SbClient < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture, primary_key: "code", foreign_key: "prefecture_code"
  belongs_to_active_hash :area
  belongs_to_active_hash :industry1, class_name: "Industry", primary_key: "code", foreign_key: "industry_code1"
  belongs_to_active_hash :industry2, class_name: "Industry", primary_key: "code", foreign_key: "industry_code2"
  belongs_to_active_hash :channel

  belongs_to :sb_tanto, optional: true, class_name: "InternalUser", foreign_key: "sb_tanto_id"
  has_many :sb_client_user
  belongs_to :entity, optional: true
  belongs_to :sb_agent, optional: true
end
