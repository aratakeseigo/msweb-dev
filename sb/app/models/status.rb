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
    { :id => 1, :code => "exam_not_detected", :name => "企業未特定" },
    { :id => 2, :code => "ready_for_confirm", :name => "確認待ち" },
    { :id => 3, :code => "ready_for_approval", :name => "決裁待ち" },
    { :id => 4, :code => "approved", :name => "決裁完了" },
    { :id => 5, :code => "replyed", :name => "回答済み" },
  ]
  enum_accessor :code
end
