class SbGuaranteeClient < ApplicationRecord
  belongs_to :sb_guarantee_client, optional: true
  has_many :sb_guarantee_exams
end
