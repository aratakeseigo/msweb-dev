class SbClientExam < ApplicationRecord
  include Approvable
  extend ActiveHash::Associations::ActiveRecordExtensions

  belongs_to :sb_approval, optional: true, class_name: "SbApproval::ClientExam"
  belongs_to :created_user, optional: true, class_name: "InternalUser", foreign_key: "created_by"
  belongs_to :updated_user, optional: true, class_name: "InternalUser", foreign_key: "updated_by"
end
