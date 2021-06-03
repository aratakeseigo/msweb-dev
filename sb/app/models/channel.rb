class Channel < ActiveHash::Base
  fields :name
  add :id => 1, :name => "広告"
  add :id => 2, :name => "代理店"
end
