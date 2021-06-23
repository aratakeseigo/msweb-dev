class SbGuaranteeCustomer < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  include Concerns::Userstamp

  belongs_to_active_hash :prefecture, primary_key: "code", foreign_key: "prefecture_code"
  has_many :sb_guarantee_exams
  belongs_to :entity, optional: true
  accepts_nested_attributes_for :entity

  validates :company_name, presence: true, length: { maximum: 255 }
  validates :daihyo_name, presence: true, length: { maximum: 255 }, user_name: true
  validates :address, allow_blank: true, length: { maximum: 255 }
  validates :tel, allow_blank: true, tel: true
  validates :taxagency_corporate_number, allow_blank: true, taxagency_corporate_number: true
  validates :prefecture, allow_blank: true, inclusion: { in: Prefecture.all, message: :inclusion_prefecture_code }

  scope :select_company_name, ->(company_name) {
          where(company_name: company_name)
        }
  scope :select_adress_choumei, ->(prefecture, address) {
      address_before_choumei = Utils::AddressUtils.substr_before_choumei(address)
      unless address_before_choumei.nil?
        address_before_choumei = Entity.sanitize_sql_like(address_before_choumei)
      end
      where(SbGuaranteeCustomer.arel_table[:address].matches("#{address_before_choumei}%"))
        .where(prefecture_code: prefecture&.code)
    }

  def company_name=(company_name)
    if company_name.blank?
      write_attribute(:company_name, company_name)
      return
    end
    write_attribute(:company_name, Utils::CompanyNameUtils.to_zenkaku_name(company_name))
  end

  def daihyo_name=(daihyo_name)
    if daihyo_name.blank?
      write_attribute(:daihyo_name, daihyo_name)
      return
    end
    write_attribute(:daihyo_name, Utils::StringUtils.to_zenkaku(daihyo_name))
  end

  def address=(address)
    if address.blank?
      write_attribute(:address, address)
      return
    end
    write_attribute(:address, Utils::StringUtils.to_zenkaku(address))
  end

  def self.assign_customer(company_name: nil, daihyo_name: nil,
                           taxagency_corporate_number: nil,
                           address: nil, prefecture: nil,
                           tel: nil)
    # 既存の保証先だった場合にはそれを返す
    ## 企業名と代表者名で特定できた場合
    sbg_clustomers = SbGuaranteeCustomer
      .select_company_name(company_name)
      .where(daihyo_name: daihyo_name)

    #この条件で1件以上ヒットすることは通常ありえないので先頭を返す
    return sbg_clustomers.first if sbg_clustomers.present? and sbg_clustomers.size == 1

    ## 法人番号と住所(町名まで)で特定できた場合
    sbg_clustomers = SbGuaranteeCustomer
      .select_adress_choumei(prefecture, address)
      .where(taxagency_corporate_number: taxagency_corporate_number)

    #この条件で1件以上ヒットすることは通常ありえないので先頭を返す
    return sbg_clustomers.first if sbg_clustomers.present? and sbg_clustomers.size >= 1

    # 既存でない場合は新規保証元を作成する
    sbg_clustomer = SbGuaranteeCustomer.new(
      company_name: company_name, daihyo_name: daihyo_name,
      taxagency_corporate_number: taxagency_corporate_number,
      prefecture: prefecture, address: address, tel: tel,
    )

    ## 新規保証先を作成した場合、
    ## 対象が絞れた場合にはExtityをアサインする
    entity = Entity.assign_or_create_entity(company_name: company_name, daihyo_name: daihyo_name,
                                            taxagency_corporate_number: taxagency_corporate_number,
                                            address: address, prefecture: prefecture, daihyo_tel: tel)

    sbg_clustomer.entity = entity if entity.present?
    sbg_clustomer
  end
end
