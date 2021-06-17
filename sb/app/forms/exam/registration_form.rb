module Exam
  class RegistrationForm < ApplicationForm
    attribute :id, :integer # クライアントID

    attr_accessor :exams, :current_user
    # , :sb_client, :entity, :status, :is_assign_new_entity

    def self.initFromFile(sb_client, file)
      column_mapping_client = {
        "法人名(保証元)" => "cl_company_name",
        "代表者名(保証元)" => "cl_address",
        "住所(保証元)" => "cl_tel",
        "TEL(保証元)" => "cl_daihyo_name",
        "法人番号(保証元)" => "cl_taxagency_corporate_number",
      }
      column_mapping_customer = {
        "法人名" => "company_name",
        "住所" => "address",
        "TEL" => "tel",
        "代表者名" => "daihyo_name",
        "法人番号" => "taxagency_corporate_number",
      }
      column_mapping_exam = {
        "取扱い商品" => "transaction_contents",
        "決済条件" => "payment_method_id",
        "決済条件補足" => "payment_method_optional",
        "取引" => "new_transaction",
        "取引歴" => "transaction_years",
        "支払い遅延" => "payment_delayed",
        "支払い遅延の状況" => "payment_delayed_memo",
        "支払条件変更" => "payment_method_changed",
        "支払条件変更内容" => "payment_method_changed_memo",
        "保証会社名" => "other_companies_ammount",
        "保証額" => "other_guarantee_companies",
        "保証希望額" => "guarantee_amount_hope",
      }
      column_mapping = (column_mapping_client.merge column_mapping_customer).merge column_mapping_exam
      exam_request_hash_list = Utils::ExcelUtils.excel_to_h(file,
                                                            worksheet_index: 0,
                                                            header_row_index: 1,
                                                            list_start_row_index: 3,
                                                            list_end_row_index: 34, #30件まで
                                                            start_col_index: 0,
                                                            end_col_index: 30,
                                                            header_mapping: column_mapping)

      form = Exam::RegistrationForm.new(sb_client)

      exam_request_hash_list.each do |h|
        next if h.values.join.blank?
        client_hash = h.select { |key| column_mapping_client.values.include? key }
        customer_hash = h.select { |key| column_mapping_customer.values.include? key }
        exam_hash = h.select { |key| column_mapping_exam.values.include? key }

        form.add_exam(client_hash, customer_hash, exam_hash)
      end
      form
    end

    def initialize(sb_client)
      @sb_client = sb_client
    end

    def add_exam(client_hash, customer_hash, exam_hash)
      @exams = [] unless @exams

      # clientを特定する（なければ新規作成）
      sbg_client = specify_client(client_hash)
      # customerを特定する（なければ新規作成）
      sbg_clustomer = specify_customer(customer_hash)
      # examを作成する
      sbg_exam = sbg_client.sb_guarantee_exams.build(
        exam_hash.merge({
          sb_client: @sb_client,
          sb_guarantee_customer: sbg_clustomer,
        })
      )

      @exams << sbg_exam
    end

    def specify_customer(customer_hash)
      ## addressに都道府県が含まれているので分割
      _address = Utils::AddressUtils.split_prefecture_and_other(customer_hash["address"])
      prefecture = _address[:prefecture]
      address = _address[:address]
      daihyo_name = customer_hash["daihyo_name"]
      company_name = customer_hash["company_name"]
      taxagency_corporate_number = customer_hash["taxagency_corporate_number"]

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
      entity = assign_entity(company_name: company_name, daihyo_name: daihyo_name,
                             taxagency_corporate_number: taxagency_corporate_number,
                             address: address,
                             prefecture: prefecture)

      if entity.present?
        sbg_clustomer.entity = entity
        return sbg_clustomer
      end

      sbg_clustomer #企業未特定のまま返却
    end

    def specify_client(client_hash)
      # 保証元情報がない場合sb_clientの情報を設定する
      if client_hash.nil? || client_hash.empty?
        return @sb_client.as_sb_guarantee_client
      end

      ## addressに都道府県が含まれているので分割
      _address = Utils::AddressUtils.split_prefecture_and_other(client_hash["cl_address"])
      prefecture = _address[:prefecture]
      address = _address[:address]
      daihyo_name = client_hash["cl_daihyo_name"]
      company_name = client_hash["cl_company_name"]
      taxagency_corporate_number = client_hash["cl_taxagency_corporate_number"]

      # 既存の保証元だった場合にはそれを返す
      ## 企業名と代表者名で特定できた場合
      sbg_clients = @sb_client.sb_guarantee_clients
        .select_company_name(company_name)
        .where(daihyo_name: daihyo_name)
      return sbg_clients.first if sbg_clients.present? and sbg_clients.size == 1

      ## 法人番号と住所(町名)で特定できた場合
      sbg_clients = @sb_client.sb_guarantee_clients
        .select_adress_choumei(address)
        .where(taxagency_corporate_number: cl_taxagency_corporate_number)
      return sbg_clients.first if sbg_clients.present? and sbg_clients.size == 1

      # 既存でない場合は新規保証元を作成する
      sbg_client = @sb_client.sb_guarantee_clients.build(
        company_name: company_name, daihyo_name: daihyo_name,
        taxagency_corporate_number: taxagency_corporate_number,
        prefecture: prefecture, address: address,
      )
      ## 新規保証先を作成した場合、
      ## 対象が絞れた場合にはExtityをアサインする
      entity = assign_entity(company_name: company_name, daihyo_name: daihyo_name,
                             taxagency_corporate_number: taxagency_corporate_number,
                             address: address,
                             prefecture: prefecture)
      if entity.present?
        sbg_client.entity = entity
        return sbg_client
      end
      sbg_client #企業未特定のまま返却
    end

    def assign_entity(company_name: nil, daihyo_name: nil,
                      taxagency_corporate_number: nil,
                      prefecture: nil, address: nil)
      entity = Entity.assign_entity(company_name: company_name, daihyo_name: daihyo_name,
                                    taxagency_corporate_number: taxagency_corporate_number,
                                    address: address)

      return entity if entity.present?

      ## 候補がない場合はExtityを作成する
      unless Entity.recommend_entity_exists?(company_name: company_name, daihyo_name: daihyo_name,
                                             taxagency_corporate_number: taxagency_corporate_number)
        entity = Entity.new(corporation_number: taxagency_corporate_number)
        entity.assign_house_company_code
        entity.build_entity_profile(corporation_name: company_name, daihyo_name: daihyo_name,
                                    prefecture: prefecture, address: address)
        entity.save!
        return entity
      end
      nil
    end

    ## 保存しないので常にtrue(rspec用)
    def save!
      return true
    end
  end
end
