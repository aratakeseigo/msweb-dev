class SbGuaranteeExam < ApplicationRecord
  include Approvable
  include Concerns::Userstamp
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :sb_client

  belongs_to :sb_client
  belongs_to :sb_guarantee_exam_request
  belongs_to :sb_guarantee_client
  belongs_to :sb_guarantee_customer

  belongs_to :sb_approval, optional: true, class_name: "SbApproval::GuaranteeExam"
  belongs_to :payment_method, optional: true
  belongs_to :hp_type, optional: true

  validates :payment_method, allow_blank: true, inclusion: { in: PaymentMethod.all, message: :not_in_master }
  validates :transaction_contents, presence: true, length: { maximum: 255 }
end
