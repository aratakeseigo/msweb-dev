class Status < ActiveHash::Base
  fields :name
  add :id => 1,  :name => "審査待ち"
  add :id => 2,  :name => "審査中"
  add :id => 3,  :name => "入力完了"
  add :id => 4,  :name => "調査完了"
end