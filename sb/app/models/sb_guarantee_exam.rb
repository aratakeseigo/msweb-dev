class SbGuaranteeExam < ApplicationRecord
  include Approvable
  include Concerns::Userstamp
  extend ActiveHash::Associations::ActiveRecordExtensions

  after_initialize :set_default_values

  belongs_to :sb_client

  belongs_to :sb_client
  belongs_to :sb_guarantee_exam_request
  belongs_to :sb_guarantee_client
  belongs_to :sb_guarantee_customer
  belongs_to :sb_approval, optional: true, class_name: "SbApproval::GuaranteeExam"
  belongs_to :hp_type, optional: true

  belongs_to_active_hash :payment_method, optional: true
  belongs_to_active_hash :hp_type, optional: true
  belongs_to_active_hash :status, class_name: "Status::ExamStatus"

  validates :accepted_at, presence: true
  validates :payment_method, allow_blank: true, inclusion: { in: PaymentMethod.all, message: :not_in_master }
  validates :transaction_contents, allow_blank: true, length: { maximum: 255 }
  validates :other_guarantee_companies, allow_blank: true, length: { maximum: 255 }
  validates :exam_search_key, presence: true, length: { maximum: 255 }

  def set_default_values
    self.status ||= Status::ExamStatus::COMPANY_NOT_DETECTED
  end
end
