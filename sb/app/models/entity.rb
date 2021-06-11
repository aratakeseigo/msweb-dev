class Entity < ActiveRecord::Base
  # 履歴は別テーブルの予定なので、profileは単体
  has_one :entity_profile
  accepts_nested_attributes_for :entity_profile
  scope :available, -> { where(show_flag: true) }

  scope :select_company_name_short, ->(company_name) {
          company_name_short = Utils::CompanyNameUtils.to_short_name(company_name)
          where(entity_profiles: { corporation_name_short: company_name_short })
        }
  scope :select_adress_choumei, ->(address) {
          address_before_choumei = Entity.sanitize_sql_like(Utils::AddressUtils.substr_before_choumei(address))
          where(EntityProfile.arel_table[:address].matches("#{address_before_choumei}%"))
        }

  def assign_house_company_code
    self.house_company_code = SeqHouseCompanyCode.generate_company_code
  end

  def enable
    self.show_flag = true
  end

  def disable
    self.show_flag = false
  end

  def enabled?
    self.show_flag
  end

  #
  # 複数ヒットがあり、特定できなかった場合はnilが返ります
  #
  def self.assign_entity(company_name: nil, daihyo_name: nil, taxagency_corporate_number: nil, address: nil)
    # 全パラメータで検索して１件一致したら特定
    recommend_entities = select_by_company_name_and_daihyo_name_company_no_and_address(company_name: company_name, address: address,
                                                                                       taxagency_corporate_number: taxagency_corporate_number)
    return recommend_entities.first if recommend_entities&.size == 1

    # 法人番号と住所の町名までで１件一致したら特定
    recommend_entities = select_by_company_no_and_address(taxagency_corporate_number: taxagency_corporate_number, address: address)
    return recommend_entities.first if recommend_entities&.size == 1
    return nil if recommend_entities.size > 1

    # 会社名と代表者で１件一致したら特定
    recommend_entities = select_by_company_name_and_daihyo_name(company_name: company_name, daihyo_name: daihyo_name)
    return recommend_entities.first if recommend_entities&.size == 1
    nil
  end

  # 法人番号と会社名と代表者でどれか一致するExtityがあるか
  def self.recommend_entity_exists?(company_name: nil, daihyo_name: nil, taxagency_corporate_number: nil)
    recommend_entities = select_by_company_name_or_daihyo_name_or_company_no(taxagency_corporate_number: taxagency_corporate_number, company_name: company_name, daihyo_name: daihyo_name)
    recommend_entities.present?
  end

  # 全パラメータで検索
  def self.select_by_company_name_and_daihyo_name_company_no_and_address(company_name: nil, daihyo_name: nil, taxagency_corporate_number: nil, address: nil)
    entities = Entity.joins(:entity_profile)
      .select_adress_choumei(address)
      .select_company_name_short(company_name)
      .where(corporation_number: taxagency_corporate_number)
      .where(entity_profiles: { daihyo_name: daihyo_name })
  end

  # 法人番号と住所の町名までで検索
  def self.select_by_company_no_and_address(taxagency_corporate_number: nil, address: nil)
    entities = Entity.joins(:entity_profile)
      .where(corporation_number: taxagency_corporate_number)
      .select_adress_choumei(address)
  end

  # 会社名と代表者で検索
  def self.select_by_company_name_and_daihyo_name(company_name: nil, daihyo_name: nil)
    entities = Entity.joins(:entity_profile)
      .select_company_name_short(company_name)
      .where(entity_profiles: { daihyo_name: daihyo_name })
  end

  # 法人番号と会社名と代表者でOR検索
  def self.select_by_company_name_or_daihyo_name_or_company_no(taxagency_corporate_number: nil, company_name: nil, daihyo_name: nil)
    entities = Entity.joins(:entity_profile).select_company_name_short(company_name)
    entities = entities + Entity.joins(:entity_profile).where(entity_profiles: { daihyo_name: daihyo_name })
    entities = entities + Entity.joins(:entity_profile).where(corporation_number: taxagency_corporate_number)
  end
end
