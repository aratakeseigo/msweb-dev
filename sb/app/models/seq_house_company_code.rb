class SeqHouseCompanyCode < ActiveRecord::Base
  def self.generate_company_code
    sequence_fetch = SeqHouseCompanyCode.create!
    "KG" + format("%09d", (sequence_fetch.id))
  end
end
