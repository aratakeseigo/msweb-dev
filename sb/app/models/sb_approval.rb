class SbApproval < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :status, class_name: "Status::SbApproval"

  belongs_to :created_user, optional: true, class_name: "InternalUser", foreign_key: "created_by"
  belongs_to :updated_user, optional: true, class_name: "InternalUser", foreign_key: "updated_by"
  belongs_to :applied_user, optional: true, class_name: "InternalUser", foreign_key: "applied_by"
  belongs_to :approved_user, optional: true, class_name: "InternalUser", foreign_key: "approved_by"
end

class SbApproval::Client < SbApproval
  has_one :client, class_name: "SbClient", foreign_key: "relation_id"
end
