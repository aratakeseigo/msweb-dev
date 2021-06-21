require "active_support/concern"

module Concerns::Userstamp
  extend ActiveSupport::Concern

  included do
    belongs_to :created_user, optional: true, class_name: "InternalUser", foreign_key: "created_by"
    belongs_to :updated_user, optional: true, class_name: "InternalUser", foreign_key: "updated_by"
  end

  def created_user=(created_user)
    write_attribute(:created_by, created_user&.id)
    self.updated_by = created_user&.id if self.updated_by.nil?
  end

  def created_by=(created_user_id)
    write_attribute(:created_by, created_user_id)
    self.updated_by = created_user_id if self.updated_by.nil?
  end
end
