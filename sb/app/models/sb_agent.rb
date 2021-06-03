class SbAgent < ApplicationRecord
  belongs_to :entity
  has_many :sb_client
end
