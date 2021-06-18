require "active_support/concern"

module Concerns::Userstamp
  extend ActiveSupport::Concern

  def created_user=(created_user)
    write_attribute(:created_by, created_user.id)
    self.updated_by = created_user.id if self.updated_by.nil?
  end
end
