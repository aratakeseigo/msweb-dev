class SbClient < ApplicationRecord
  has_many :sb_client_user
  belongs_to :entity
  belongs_to :sb_agent, optional: true
end
