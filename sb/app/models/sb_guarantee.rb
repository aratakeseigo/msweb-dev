class SbGuarantee < ApplicationRecord
  include Approvable
  include Concerns::Userstamp
  extend ActiveHash::Associations::ActiveRecordExtensions

  after_initialize :set_default_values

  belongs_to :sb_client
  belongs_to :sb_guarantee_request
  belongs_to :sb_guarantee_exam
  belongs_to :sb_guarantee_client
  belongs_to :sb_guarantee_customer
  belongs_to :sb_approval, optional: true, class_name: "SbApproval::Guarantee"
  belongs_to_active_hash :status, class_name: "Status::GuaranteeStatus"

  validates :company_name, presence: true, length: { maximum: 255 }
  validates :daihyo_name, presence: true, length: { maximum: 255 }, user_name: true
  validates :client_company_name, allow_blank: true, length: { maximum: 255 }
  validates :client_daihyo_name, allow_blank: true, length: { maximum: 255 }, user_name: true
  validates :exam_search_key, presence: true, length: { maximum: 255 }

  validates :guarantee_start_at, presence: true
  validates :guarantee_end_at, presence: true
  validates :guarantee_amount_hope, presence: true
  validates :guarantee_amount, presence: true

  def set_default_values
    self.status ||= Status::GuaranteeStatus::EXAM_NOT_DETECTED
  end

  def company_name=(company_name)
    if company_name.blank?
      write_attribute(:company_name, company_name)
      return
    end
    write_attribute(:company_name, Utils::CompanyNameUtils.to_zenkaku_name(company_name))
  end

  def daihyo_name=(daihyo_name)
    if daihyo_name.blank?
      write_attribute(:daihyo_name, daihyo_name)
      return
    end
    write_attribute(:daihyo_name, Utils::StringUtils.to_zenkaku(daihyo_name))
  end

  def client_company_name=(client_company_name)
    if client_company_name.blank?
      write_attribute(:client_company_name, client_company_name)
      return
    end
    write_attribute(:client_company_name, Utils::CompanyNameUtils.to_zenkaku_name(client_company_name))
  end

  def client_daihyo_name=(client_daihyo_name)
    if client_daihyo_name.blank?
      write_attribute(:client_daihyo_name, client_daihyo_name)
      return
    end
    write_attribute(:client_daihyo_name, Utils::StringUtils.to_zenkaku(client_daihyo_name))
  end
end
