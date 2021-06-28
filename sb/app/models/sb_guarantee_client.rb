class SbGuaranteeClient < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  include Concerns::Userstamp

  belongs_to_active_hash :prefecture, primary_key: "code", foreign_key: "prefecture_code"
  belongs_to :sb_client
  belongs_to :entity, optional: true
  has_many :sb_guarantee_exams

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
      where(SbGuaranteeClient.arel_table[:address].matches("#{address_before_choumei}%"))
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

  def self.assign_client(sb_client,
                         company_name: nil, daihyo_name: nil,
                         taxagency_corporate_number: nil,
                         prefecture: nil, address: nil, tel: nil)
    # 既存の保証元だった場合にはそれを返す
    ## 企業名と代表者名で特定できた場合
    sbg_clients = sb_client.sb_guarantee_clients
      .select_company_name(company_name)
      .where(daihyo_name: daihyo_name)

    #この条件で1件以上ヒットすることは通常ありえないので先頭を返す
    return sbg_clients.first if sbg_clients.present? and sbg_clients.size >= 1

    ## 法人番号と住所(町名まで)で特定できた場合
    sbg_clients = sb_client.sb_guarantee_clients
      .select_adress_choumei(prefecture, address)
      .where(taxagency_corporate_number: taxagency_corporate_number)

    #この条件で1件以上ヒットすることは通常ありえないので先頭を返す
    return sbg_clients.first if sbg_clients.present? and sbg_clients.size >= 1

    # 既存でない場合は新規保証元を作成する
    sbg_client = sb_client.sb_guarantee_clients.build(
      company_name: company_name, daihyo_name: daihyo_name,
      taxagency_corporate_number: taxagency_corporate_number,
      prefecture: prefecture, address: address, tel: tel,
    )
    ## 新規保証先を作成した場合、
    ## 対象が絞れた場合にはEntityをアサインする
    entity = Entity.assign_or_create_entity(company_name: company_name, daihyo_name: daihyo_name,
                                            taxagency_corporate_number: taxagency_corporate_number,
                                            address: address,
                                            prefecture: prefecture, daihyo_tel: tel)
    if entity.present?
      sbg_client.entity = entity
    end
    sbg_client
  end

  def self.assign_client_myself(sb_client)
    # 自身のクライアントを自身のEntityIDで検索して存在した場合自身が登録済みなのでそれを返す
    my_clients_myself = sb_client.sb_guarantee_clients.where(entity_id: sb_client.entity_id)
    return my_clients_myself.first unless my_clients_myself.empty?

    # そうでない場合は新しく登録する
    sb_guarantee_client = sb_client.sb_guarantee_clients.build
    sb_guarantee_client.company_name = sb_client.name
    sb_guarantee_client.daihyo_name = sb_client.daihyo_name
    sb_guarantee_client.prefecture = sb_client.prefecture
    sb_guarantee_client.address = sb_client.address
    sb_guarantee_client.tel = sb_client.tel
    sb_guarantee_client.taxagency_corporate_number = sb_client.taxagency_corporate_number
    sb_guarantee_client.entity_id = sb_client.entity_id
    sb_guarantee_client
  end
end
