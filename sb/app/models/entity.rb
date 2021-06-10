class Entity < ActiveRecord::Base
  # 履歴は別テーブルの予定なので、profileは単体
  has_one :entity_profile
  accepts_nested_attributes_for :entity_profile


  def self.assign_entity(company_name,daihyo_name,taxagency_corporate_number,address)
    address_before_choumei = address
    recommends = find_by_company_no_and_address(taxagency_corporate_number,address)

  end

  def self.select_by_company_no_and_address(taxagency_corporate_number,address)
  end


  def self.select_by_company_name_and_daihyo_name(company_name,daihyo_name,)
  end

end
