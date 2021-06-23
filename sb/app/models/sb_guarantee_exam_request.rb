class SbGuaranteeExamRequest < ApplicationRecord
  include Concerns::Userstamp
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :sb_client
  has_many :sb_guarantee_exams
end
