class SbClient < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture, primary_key: "code", foreign_key: "prefecture_code"
  belongs_to_active_hash :area
  belongs_to_active_hash :industry
  belongs_to_active_hash :channel
  belongs_to_active_hash :status, class_name: "Status::ClientStatus"

  belongs_to :sb_tanto, optional: true, class_name: "InternalUser", foreign_key: "sb_tanto_id"
  belongs_to :created_user, optional: true, class_name: "InternalUser", foreign_key: "created_by"
  belongs_to :updated_user, optional: true, class_name: "InternalUser", foreign_key: "updated_by"

  has_many :sb_client_users
  has_many :sb_client_exams
  belongs_to :entity, optional: true
  belongs_to :sb_agent, optional: true

  has_one_attached :registration_form_file, dependent: :destroy
  has_many_attached :other_files, dependent: :destroy

  validates :name, presence: true, length: { maximum: 255 }
  validates :daihyo_name, presence: true, length: { maximum: 255 }, user_name: true
  validates :zip_code, allow_blank: true, zip_code: true
  validates :address, allow_blank: true, length: { maximum: 255 }
  validates :tel, allow_blank: true, tel: true
  validates :industry_optional, allow_blank: true, length: { maximum: 255 }
  validates :established_in, allow_blank: true, yyyymm: true
  validates :capital, allow_blank: true, numericality: { only_integer: true }
  validates :annual_sales, allow_blank: true, numericality: { only_integer: true }
  validates :taxagency_corporate_number, allow_blank: true, taxagency_corporate_number: true

  validates :prefecture, allow_blank: true, inclusion: { in: Prefecture.all, message: :inclusion_prefecture_code }
  validates :industry, allow_blank: true, inclusion: { in: Industry.all, message: :not_in_master }
  validates :channel, allow_blank: true, inclusion: { in: Channel.all, message: :not_in_master }
  validates :sb_agent, allow_blank: true, inclusion: { in: Proc.new { SbAgent.all }, message: :not_in_master }
  validates :area, allow_blank: true, inclusion: { in: Area.all, message: :not_in_master }
end
