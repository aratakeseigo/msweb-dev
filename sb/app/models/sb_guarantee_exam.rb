class SbGuaranteeExam < ApplicationRecord
  include Approvable
  include Concerns::Userstamp
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :sb_client
  belongs_to :created_user, optional: true, class_name: "InternalUser", foreign_key: "created_by"
  belongs_to :updated_user, optional: true, class_name: "InternalUser", foreign_key: "updated_by"

  belongs_to :sb_client
  belongs_to :sb_guarantee_client
  belongs_to :sb_guarantee_customer

  belongs_to :sb_approval, optional: true, class_name: "SbApproval::GuaranteeExam"
  belongs_to :payment_method, optional: true
  belongs_to :hp_type, optional: true
end
