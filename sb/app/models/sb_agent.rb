class SbAgent < ApplicationRecord
  belongs_to :entity
  has_many :sb_client

  def find_by_name(name)
    find_by(name: name)
  end
end
