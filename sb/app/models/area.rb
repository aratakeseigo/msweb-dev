class Area < ActiveHash::Base
  fields :name
  add :id => 1, :name => "東京"
  add :id => 2, :name => "関西"
  add :id => 3, :name => "中部"
end
