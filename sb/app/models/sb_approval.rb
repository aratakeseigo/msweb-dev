class SbApproval < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  include Concerns::Userstamp

  belongs_to_active_hash :status, class_name: "Status::SbApproval"

  belongs_to :applied_user, optional: true, class_name: "InternalUser", foreign_key: "applied_by"
  belongs_to :approved_user, optional: true, class_name: "InternalUser", foreign_key: "approved_by"

  def has_approvable_permission?(_user)
    raise StandardError.new("承認時の権限チェックをサブクラスで実装してください。特にない場合はtrueを返却してください")
  end

  def apply(user, comment = "")
    # 申請が存在しないか、
    # 申請が存在した場合、
    self.applied_user = user
    self.applied_at = Time.zone.now
    self.apply_comment = comment
    self.created_user = user
    self.updated_user = user
    self.status = Status::SbApproval::APLYING
    self
  end

  def re_apply(user, comment = "")
    #   承認済みならできない
    #   取り下げ済みもしくは差し戻し済み以外は再申請できない
    if Status::SbApproval::APPROVED == status
      raise ApproveError.new "承認済みです"
    end
    unless [Status::SbApproval::WITHDRAWED, Status::SbApproval::REMAND].include? status
      raise ApproveError.new "申請中です"
    end
    approval = Object.const_get(self.class.name).new
    approval.type = self.type
    approval.relation_id = self.relation_id
    approval.apply(user, comment)
    approval
  end

  def withdraw(user, comment = "")
    # 申請中でない場合は取り下げできない
    # 申請者しか取り下げできない
    raise ApproveError.new "申請中ではありません" unless status == Status::SbApproval::APLYING
    raise ApproveError.new "申請者しか取り下げできません" unless applied_user == user
    self.approve_comment = comment
    self.approved_at = Time.zone.now
    self.updated_user = user
    self.status = Status::SbApproval::WITHDRAWED
    self
  end

  def approve(user, comment = "")
    # 申請中でない場合は承認できない
    # 申請者は承認できない
    raise ApproveError.new "申請中ではありません" unless status == Status::SbApproval::APLYING
    raise ApproveError.new "申請者は承認できません" unless applied_user != user
    raise ApproveError.new "権限がありません" unless has_approvable_permission?(user)
    self.approved_user = user
    self.approve_comment = comment
    self.approved_at = Time.zone.now
    self.updated_user = user
    self.status = Status::SbApproval::APPROVED
    self
  end

  def remand(user, comment = "")
    # 申請中でない場合は承認できない
    # 申請者は承認できない
    raise ApproveError.new "申請中ではありません" unless status == Status::SbApproval::APLYING
    raise ApproveError.new "申請者は差し戻しできません" unless applied_user != user

    self.approved_user = user
    self.approve_comment = comment
    self.approved_at = Time.zone.now
    self.updated_user = user
    self.status = Status::SbApproval::REMAND
    self
  end

  class ApproveError < StandardError; end
end

class SbApproval::ClientExam < SbApproval
  belongs_to :sb_client_exam, class_name: "SbClientExam", foreign_key: "relation_id"

  def has_approvable_permission?(user)
    # 特にチェックなし
    # 審査対象を参照したい場合はrelationでたどれます
    # sb_client_exam.sb_client

    # ユーザがマネージャー以上かどうかチェック
    user.is_position_upper_than_or_equal?(SbUserPosition::MANAGER)
  end
end

class SbApproval::GuaranteeExam < SbApproval
  belongs_to :sb_guarantee_exam, class_name: "SbGuaranteeExam", foreign_key: "relation_id"

  def has_approvable_permission?(_user)
    # 役職ごとの金額チェック
    true
  end
end

class SbApproval::Guarantee < SbApproval
  belongs_to :sb_guarantee, class_name: "SbGuarantee", foreign_key: "relation_id"

  def has_approvable_permission?(user)
    # 特にない予定
    true
  end
end
