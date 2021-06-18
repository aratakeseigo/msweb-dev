class PaymentMethod < ActiveHash::Base
  fields :name, :site_days
  add :id => 1, :name => "末・末", :site_days => 30
  add :id => 2, :name => "末・翌々末", :site_days => 60
end
