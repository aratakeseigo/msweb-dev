class SbGuaranteeCustomer < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  include Concerns::Userstamp

  belongs_to_active_hash :prefecture, primary_key: "code", foreign_key: "prefecture_code"
  has_many :sb_guarantee_exams
  belongs_to :entity, optional: true
  belongs_to :created_user, optional: true, class_name: "InternalUser", foreign_key: "created_by"
  belongs_to :updated_user, optional: true, class_name: "InternalUser", foreign_key: "updated_by"

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

  def self.specify_customer(user,
                            company_name: nil, daihyo_name: nil,
                            taxagency_corporate_number: nil,
                            address: nil, prefecture: nil)
    # 既存の保証先だった場合にはそれを返す
    ## 企業名と代表者名で特定できた場合
    sbg_clustomers = SbGuaranteeCustomer
      .select_company_name(company_name)
      .where(daihyo_name: daihyo_name)
    return sbg_clustomers.first if sbg_clustomers.present? and sbg_clustomers.size == 1

    ## 法人番号と住所(町名)で特定できた場合
    sbg_clustomers = SbGuaranteeCustomer
      .select_adress_choumei(address)
      .where(taxagency_corporate_number: taxagency_corporate_number)
    return sbg_clustomers.first if sbg_clustomers.present? and sbg_clustomers.size == 1

    # 既存でない場合は新規保証元を作成する
    sbg_clustomer = SbGuaranteeCustomer.new(
      company_name: company_name, daihyo_name: daihyo_name,
      taxagency_corporate_number: taxagency_corporate_number,
      prefecture: prefecture, address: address,
    )

    ## 新規保証先を作成した場合、
    ## 対象が絞れた場合にはExtityをアサインする
    entity = Entity.assign_or_create_entity(company_name: company_name, daihyo_name: daihyo_name,
                                            taxagency_corporate_number: taxagency_corporate_number,
                                            address: address,
                                            prefecture: prefecture)

    sbg_clustomer.entity = entity if entity.present?
    sbg_clustomer.created_user = user
    sbg_clustomer.save!
    sbg_clustomer
  end
end
