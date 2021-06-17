class SbGuaranteeCustomer < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture, primary_key: "code", foreign_key: "prefecture_code"
  has_many :sb_guarantee_exams
  belongs_to :entity, optional: true

  scope :select_company_name, ->(company_name) {
          where(company_name: company_name)
        }
  scope :select_adress_choumei, ->(address) {
      address_before_choumei = Utils::AddressUtils.substr_before_choumei(address)
      unless address_before_choumei.nil?
        address_before_choumei = Entity.sanitize_sql_like(address_before_choumei)
      end
      where(SbGuaranteeCustomer.arel_table[:address].matches("#{address_before_choumei}%"))
    }
end
