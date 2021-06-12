module Approvable
  def apply(user, comment = "", target = self)
    approval = target.approval
    if approval.nil?
      approval = target.build_approval
      approval.relation_id = target.id
      approval.apply(user, comment)
    else
      target.approval = approval.re_apply(user, comment)
    end
    target.save!
  end

  def withdraw(user, comment = "", target = self)
    raise ApproveError.new "未申請です" if approval.nil?
    approval = target.approval
    approval.withdraw(user, comment)
    approval.save!
  end

  def approve(user, comment = "", target = self)
    raise ApproveError.new "未申請です" if approval.nil?
    approval = target.approval
    approval.approve(user, comment)
    approval.save!
  end

  def remand(user, comment = "", target = self)
    raise ApproveError.new "未申請です" if approval.nil?
    approval = target.approval
    approval.remand(user, comment)
    approval.save!
  end

  def approval_histories(target = self)
    return [] unless target.approval.present?
    approval_clazz = Object.const_get(target.approval.class.name)
    approval_clazz.where(relation_id: id).order(:created_at)
  end

  class ApproveError < StandardError; end
end
