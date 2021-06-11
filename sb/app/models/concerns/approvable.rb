module Approvable
  def apply(user, comment = "", target = self)
    # 申請が存在しないか、
    # 申請が存在した場合、
    #   承認済みならできない
    #   取り下げ済みもしくは差し戻し済みなら申請できる
    unless target.approval.nil?
      if Status::SbApproval::APPROVED == target.approval.status
        raise ApproveError.new "承認済みです"
      end
      unless [Status::SbApproval::WITHDRAWED, Status::SbApproval::REMAND].include? target.approval.status
        raise ApproveError.new "申請中です"
      end
    end
    approval = target.build_approval
    approval.applied_user = user
    approval.applied_at = Time.zone.now
    approval.apply_comment = comment
    approval.created_user = user
    approval.updated_user = user
    approval.status = Status::SbApproval::APLYING
    approval.relation_id = target.id
  end

  def withdraw(user, comment = "", target = self)
    # 申請中でない場合は取り下げできない
    # 申請者しか取り下げできない
    approval = target.approval
    raise ApproveError.new "未申請です" if approval.nil?
    raise ApproveError.new "申請中ではありません" unless approval.status == Status::SbApproval::APLYING
    raise ApproveError.new "申請者しか取り下げできません" unless approval.applied_user == user
    approval = target.approval
    approval.approve_comment = comment
    approval.updated_user = user
    approval.status = Status::SbApproval::WITHDRAWED
    approval.save!
  end

  def approve(user, comment = "", target = self, &_)
    # 申請中でない場合は承認できない
    # 申請者は承認できない
    approval = target.approval
    raise ApproveError.new "未申請です" if approval.nil?
    raise ApproveError.new "申請中ではありません" unless approval.status == Status::SbApproval::APLYING
    raise ApproveError.new "申請者は承認できません" unless approval.applied_user != user
    if block_given?
      raise ApproveError.new "権限がありません" unless yield
    end
    approval.approved_at = Time.zone.now
    approval.approved_user = user
    approval.approve_comment = comment
    approval.updated_user = user
    approval.status = Status::SbApproval::APPROVED
    approval.save!
  end

  def remand(user, comment = "", target = self)
    # 申請中でない場合は承認できない
    # 申請者は承認できない
    approval = target.approval
    raise ApproveError.new "未申請です" if approval.nil?
    raise ApproveError.new "申請中ではありません" unless approval.status == Status::SbApproval::APLYING
    raise ApproveError.new "申請者は差し戻しできません" unless approval.applied_user != user

    approval.approved_at = Time.zone.now
    approval.approved_user = user
    approval.approve_comment = comment
    approval.updated_user = user
    approval.status = Status::SbApproval::REMAND
    approval.save!
  end

  def approval_histories(target = self)
    return [] unless target.approval.present?
    approval_clazz = Object.const_get(target.approval.class.name)
    approval_clazz.where(relation_id: id).order(:created_at)
  end

  class ApproveError < StandardError; end
end
