class HpType < ActiveHash::Base
  fields :name
  add :id => 1, :name => "自社HP"
  add :id => 2, :name => "紹介サイト"
  add :id => 3, :name => "求人情報"
  add :id => 4, :name => "電話帳・地図"
  add :id => 5, :name => "法人情報"
  add :id => 999, :name => "その他"
end
