class SbGuaranteeRequest < ApplicationRecord
  include Concerns::Userstamp
  belongs_to :sb_client
  has_many :sb_guarantees
  has_one_attached :guarantee_request_file, dependent: :destroy
end
