class SbGuaranteeExamRequest < ApplicationRecord
  include Concerns::Userstamp
  belongs_to :sb_client
  has_many :sb_guarantee_exams
  has_one_attached :guarantee_exam_request_file, dependent: :destroy
end
