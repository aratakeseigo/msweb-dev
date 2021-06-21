module Exam
  class RegistrationForm < ApplicationForm
    attribute :id, :integer # クライアントID

    attr_accessor :exams

    validate :exam_validate?

    def exam_validate?
      if exams.nil? || exams.empty?
        errors.add(:exams, :not_empty)
        return
      end
      exams.each.with_index(1) do |exam, num|
        unless exam.valid?
          exam.errors.each do |attr, error|
            errors.add(attr, error + "[#{num}行目]")
          end
        end
        unless exam.sb_guarantee_customer.valid?
          exam.sb_guarantee_customer.errors.each do |attr, error|
            errors.add(attr, error + "[#{num}行目]")
          end
        end
        unless exam.sb_guarantee_client.valid?
          exam.sb_guarantee_client.errors.each do |attr, error|
            errors.add(attr, error + "[#{num}行目]")
          end
        end
      end
    end

    def self.initFromFile(sb_client, current_user, file)
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

      form = Exam::RegistrationForm.new(sb_client, current_user)

      exam_request_hash_list.each do |h|
        next if h.values.join.blank?
        client_hash = h.select { |key| column_mapping_client.values.include? key }
        customer_hash = h.select { |key| column_mapping_customer.values.include? key }
        exam_hash = h.select { |key| column_mapping_exam.values.include? key }

        form.add_exam(client_hash, customer_hash, exam_hash)
      end
      form
    end

    def initialize(sb_client, current_user)
      @sb_client = sb_client
      @current_user = current_user
      # @file = file
      @sb_guarantee_exam_request = sb_client.sb_guarantee_exam_requests.create(created_user: current_user)
    end

    def add_exam(client_hash, customer_hash, exam_hash)
      @exams = [] unless @exams.present?

      # clientを特定する（なければ新規作成）
      sbg_client = specify_client(client_hash || {})
      # customerを特定する（なければ新規作成）
      sbg_clustomer = specify_customer(customer_hash)
      # examを作成する
      sbg_exam = sbg_client.sb_guarantee_exams.build(
        exam_hash.merge({
          sb_client: @sb_client,
          sb_guarantee_customer: sbg_clustomer,
          sb_guarantee_exam_request: @sb_guarantee_exam_request,
        })
      )

      @exams << sbg_exam
      sbg_exam
    end

    def specify_customer(customer_hash)
      ## addressに都道府県が含まれているので分割
      full_address = Utils::AddressUtils.split_prefecture_and_other(customer_hash["address"])
      prefecture = full_address[:prefecture]
      address = full_address[:address]
      daihyo_name = customer_hash["daihyo_name"]
      company_name = customer_hash["company_name"]
      taxagency_corporate_number = customer_hash["taxagency_corporate_number"]
      tel = customer_hash["tel"]
      SbGuaranteeCustomer.specify_customer(@current_user, company_name: company_name, daihyo_name: daihyo_name,
                                                          taxagency_corporate_number: taxagency_corporate_number,
                                                          prefecture: prefecture, address: address, tel: tel)
    end

    def specify_client(client_hash)
      # 保証元情報がない場合sb_clientの情報を設定する
      if client_hash.nil? || client_hash.values.compact.empty?
        return SbGuaranteeClient.assign_client_myself(@sb_client, @current_user)
      end

      ## addressに都道府県が含まれているので分割
      full_address = Utils::AddressUtils.split_prefecture_and_other(client_hash["cl_address"])
      prefecture = full_address[:prefecture]
      address = full_address[:address]
      daihyo_name = client_hash["cl_daihyo_name"]
      company_name = client_hash["cl_company_name"]
      taxagency_corporate_number = client_hash["cl_taxagency_corporate_number"]
      tel = client_hash["cl_tel"]

      SbGuaranteeClient.assign_client(@sb_client,
                                      @current_user,
                                      company_name: company_name, daihyo_name: daihyo_name,
                                      taxagency_corporate_number: taxagency_corporate_number,
                                      prefecture: prefecture, address: address, tel: tel)
    end

    ## 保存しないので常にtrue(rspec用)
    def save!
      return true
    end
  end
end
