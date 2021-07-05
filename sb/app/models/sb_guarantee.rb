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
  validates :daihyo_name, presence: true, length: { maximum: 255 }
  validates :exam_search_key, presence: true, length: { maximum: 255 }

  def set_default_values
    self.status ||= Status::GuaranteeStatus::EXAM_NOT_DETECTED
  end
end
