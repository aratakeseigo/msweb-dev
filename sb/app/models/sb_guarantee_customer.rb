class SbGuaranteeCustomer < ApplicationRecord
  has_many :sb_guarantee_exams
  belongs_to :entity

  belongs_to :created_user, optional: true, class_name: "InternalUser", foreign_key: "created_by"
  belongs_to :updated_user, optional: true, class_name: "InternalUser", foreign_key: "updated_by"
end
