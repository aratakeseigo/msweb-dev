class SbUserPosition < ActiveHash::Base
  include ActiveHash::Enum
  fields :name, :code, :approvable_amount

  # 権限レベルで課長以上といった場合にはIDで比較するので
  # 追加する際はは適切なIDでを設定してください
  self.data = [
    { :id => 10, :code => "Staff", :name => "社員", :approvable_amount => 200 * 10000 },
    { :id => 20, :code => "Leader", :name => "リーダー", :approvable_amount => 500 * 10000 },
    { :id => 30, :code => "Manager", :name => "マネージャー", :approvable_amount => 500 * 10000 },
    { :id => 40, :code => "SubDirector", :name => "副部長", :approvable_amount => 500 * 10000 },
    { :id => 50, :code => "SeniorManager", :name => "担当部長", :approvable_amount => 1000 * 10000 },
    { :id => 60, :code => "Director", :name => "部長", :approvable_amount => 1000 * 100000 },
    { :id => 70, :code => "Board", :name => "担当取締役", :approvable_amount => 2000 * 10000 },
    { :id => 80, :code => "President", :name => "社長", :approvable_amount => 5000 * 10000 },
    { :id => 90, :code => "Boards", :name => "取締役会", :approvable_amount => 9999999 * 10000 }, # 大きな値を設定
  ]
  enum_accessor :code

  def is_upper_than_or_equal(base_position)
    self.id >= base_position.id
  end
end
