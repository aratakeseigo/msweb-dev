module Approvable
  def apply(user, comment = "", target = self)
    sb_approval = target.sb_approval
    if sb_approval.nil?
      sb_approval = target.build_sb_approval
      sb_approval.relation_id = target.id
      sb_approval.apply(user, comment)
    else
      target.sb_approval = sb_approval.re_apply(user, comment)
    end
    target.save!
  end

  def withdraw(user, comment = "", target = self)
    raise ApproveError.new "未申請です" if target.sb_approval.nil?
    sb_approval = target.sb_approval
    sb_approval.withdraw(user, comment)
    sb_approval.save!
  end

  def approve(user, comment = "", target = self)
    raise ApproveError.new "未申請です" if target.sb_approval.nil?
    sb_approval = target.sb_approval
    sb_approval.approve(user, comment)
    sb_approval.save!
  end

  def remand(user, comment = "", target = self)
    raise ApproveError.new "未申請です" if target.sb_approval.nil?
    sb_approval = target.sb_approval
    sb_approval.remand(user, comment)
    sb_approval.save!
  end

  def sb_approval_histories(target = self)
    return [] unless target.sb_approval.present?
    sb_approval_clazz = Object.const_get(target.sb_approval.class.name)
    sb_approval_clazz.where(relation_id: id).order(:created_at)
  end

  def can_apply?(target = self)
    sb_approval = target.sb_approval
    if sb_approval.nil?
      return true
    elsif sb_approval.status == Status::SbApproval::WITHDRAWED || sb_approval.status == Status::SbApproval::REMAND
      return true
    else
      return false
    end
  end

  class ApproveError < StandardError; end
end
