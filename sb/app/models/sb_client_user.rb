class SbClientUser < ApplicationRecord
  belongs_to :sb_client

  validates :name, presence: true, length: { maximum: 255 }
  validates :name_kana, presence: true, length: { maximum: 255 }

  validates :contact_tel, allow_blank: true, tel: true
  validates :email, allow_blank: true, email: true

  validates :position, allow_blank: true, length: { maximum: 255 }
  validates :department, allow_blank: true, length: { maximum: 255 }
end
