class Status < ActiveHash::Base
  include ActiveHash::Enum
  fields :name, :code
end

class Status::ClientStatus < Status
  self.data = [
    { :id => 1, :code => "company_not_detected", :name => "企業未特定" },
    { :id => 2, :code => "ready_for_exam", :name => "審査待ち" },
    { :id => 3, :code => "ready_for_approval", :name => "決裁待ち" },
    { :id => 4, :code => "approved", :name => "決裁完了" },
    { :id => 5, :code => "contracted", :name => "契約済み" },
  ]
  enum_accessor :code
end

class Status::ExamStatus < Status
  self.data = [
    { :id => 1, :code => "company_not_detected", :name => "企業未特定" },
    { :id => 2, :code => "ready_for_exam", :name => "審査待ち" },
    { :id => 3, :code => "ready_for_approval", :name => "決裁待ち" },
    { :id => 4, :code => "approved", :name => "決裁完了" },
    { :id => 5, :code => "replyed", :name => "回答済み" },
  ]
  enum_accessor :code
end

class Status::GuaranteeStatus < Status
  self.data = [
    { :id => 1, :code => "exam_not_detected", :name => "審査未特定" }, #実際にはエラーになるのでない
    { :id => 2, :code => "ready_for_confirm", :name => "確認待ち" },
    { :id => 3, :code => "ready_for_approval", :name => "決裁待ち" },
    { :id => 4, :code => "approved", :name => "決裁完了" },
    { :id => 5, :code => "replyed", :name => "回答済み" },
  ]
  enum_accessor :code
end

class Status::SbApproval < Status
  self.data = [
    { :id => 0, :code => "APLYING", :name => "申請中" },
    { :id => 1, :code => "APPROVED", :name => "承認" },
    { :id => 8, :code => "WITHDRAWED", :name => "取り下げ" },
    { :id => 9, :code => "REMAND", :name => "差し戻し" },
  ]
  enum_accessor :code
end
