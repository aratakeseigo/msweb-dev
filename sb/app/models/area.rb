class Area < ActiveHash::Base
  fields :name
  add :id => 1, :name => "東日本"
  add :id => 2, :name => "西日本"

  def find_by_name(name)
    find_by(name: name)
  end
end
