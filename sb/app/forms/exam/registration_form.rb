module Exam
  class RegistrationForm < ApplicationForm
    include ActiveStorage::Downloading

    TRANSACTION_TYPE_NEW = "新規" # "既存"
    UMU_YES = "有" # "無"

    attr_accessor :exams, :sb_guarantee_exam_request

    validate :exam_validate?

    # 保証審査IDから初期化する（create時に使用）
    def self.initFromGuaranteeExamRequestId(sb_client, current_user, id)
      begin
        sb_guarantee_exam_request = sb_client.sb_guarantee_exam_requests.find(id)

        # 保証審査依頼からファイルを取得して読み込み処理を呼び出す
        Utils::ActivestrageFileOpener.new(sb_guarantee_exam_request.guarantee_exam_request_file).open do |file|
          initFromGuaranteeExamRequest(sb_client, current_user, sb_guarantee_exam_request, file)
        end
      rescue ActiveRecord::RecordNotFound => e
        # 保証審査依頼IDが見つからなかった場合
        raise ArgumentError.new("不正な操作です。ファイルアップロードからやり直してください。" + "(CLIENT_ID:#{sb_client.id},REQUEST_ID:#{id})")
      end
    end

    # 保証審査依頼ファイルから初期化する（upload時に使用）
    def self.initFromFile(sb_client, current_user, upload_file)
      # 保証審査依頼を作成してファイルを添付する
      sb_guarantee_exam_request = sb_client.sb_guarantee_exam_requests.create(
        created_user: current_user,
      )
      sb_guarantee_exam_request.save
      sb_guarantee_exam_request.guarantee_exam_request_file.attach upload_file
      # ファイル読み込み処理を呼び出す
      initFromGuaranteeExamRequest(sb_client, current_user, sb_guarantee_exam_request, upload_file.tempfile)
    end

    # 共通のファイル読み込み処理
    def self.initFromGuaranteeExamRequest(sb_client, current_user, sb_guarantee_exam_request, file)
      column_mapping_client = {
        "法人名(保証元)" => "cl_company_name",
        "代表者名(保証元)" => "cl_daihyo_name",
        "住所(保証元)" => "cl_full_address",
        "TEL(保証元)" => "cl_tel",
        "法人番号(保証元)" => "cl_taxagency_corporate_number",
      }
      column_mapping_customer = {
        "法人名" => "company_name",
        "住所" => "full_address",
        "TEL" => "tel",
        "代表者名" => "daihyo_name",
        "法人番号" => "taxagency_corporate_number",
      }
      column_mapping_exam = {
        "取扱い商品" => "transaction_contents",
        "決済条件" => "payment_method_name",
        "決済条件補足" => "payment_method_optional",
        "取引" => "new_transaction_name",
        "取引歴" => "transaction_years",
        "支払い遅延" => "payment_delayed_umu",
        "支払い遅延の状況" => "payment_delayed_memo",
        "支払条件変更" => "payment_method_changed_umu",
        "支払条件変更内容" => "payment_method_changed_memo",
        "保証会社名" => "other_guarantee_companies",
        "保証額" => "other_companies_ammount",
        "保証希望額" => "guarantee_amount_hope",
      }
      column_mapping = (column_mapping_client.merge column_mapping_customer).merge column_mapping_exam
      exam_request_hash_list = Utils::ExcelUtils.excel_to_h(file,
                                                            worksheet_index: 0,
                                                            header_row_index: 1,
                                                            list_start_row_index: 3,
                                                            list_end_row_index: 204, #200件まで
                                                            start_col_index: 0,
                                                            end_col_index: 30,
                                                            header_mapping: column_mapping)

      form = Exam::RegistrationForm.new(sb_client, current_user, sb_guarantee_exam_request)

      exam_request_hash_list.each do |h|
        next if h.values.join.blank?
        client_hash = h.select { |key| column_mapping_client.values.include? key }
        customer_hash = h.select { |key| column_mapping_customer.values.include? key }
        exam_hash = h.select { |key| column_mapping_exam.values.include? key }

        form.add_exam(client_hash, customer_hash, exam_hash)
      end
      form
    end

    def initialize(sb_client, current_user, sb_guarantee_exam_request)
      @sb_client = sb_client
      @current_user = current_user
      @sb_guarantee_exam_request = sb_guarantee_exam_request
    end

    def client_name
      @sb_client.name
    end

    def save_exams
      exams.each do |exam|
        # 再度特定する
        # 同じファイルに同じ保証元、保証先がいた場合に再利用するため
        sbg_client = specify_client(exam.sb_guarantee_client.attributes)
        sbg_clustomer = specify_customer(exam.sb_guarantee_customer.attributes)

        # それぞれ既存（保存済み）でなければ作成ユーザーを設定
        sbg_client.created_user = @current_user unless sbg_client.persisted?
        sbg_clustomer.created_user = @current_user unless sbg_clustomer.persisted?

        exam.sb_guarantee_client = sbg_client
        exam.sb_guarantee_customer = sbg_clustomer
        if sbg_client.entity.present? and sbg_clustomer.entity.present?
          exam.status = Status::ExamStatus::READY_FOR_EXAM
        else
          exam.status = Status::ExamStatus::COMPANY_NOT_DETECTED
        end
        exam.created_user = @current_user
        exam.save!
      end
      exams
    end

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

    def add_exam(client_hash, customer_hash, exam_hash)
      @exams = [] unless @exams.present?
      # clientを特定する（なければ新規作成）
      sbg_client = specify_client(adjust_to_client_attributes(client_hash))
      # customerを特定する（なければ新規作成）
      sbg_clustomer = specify_customer(adjust_to_customer_attributes(customer_hash))
      # examを作成する
      sbg_exam = sbg_client.sb_guarantee_exams.build(
        adjust_to_exam_attributes(exam_hash).merge({
          sb_client: @sb_client,
          sb_guarantee_customer: sbg_clustomer,
          sb_guarantee_exam_request: @sb_guarantee_exam_request,
          accepted_at: Time.zone.now,
        })
      )
      @exams << sbg_exam
      sbg_exam
    end

    def adjust_to_client_attributes(client_hash)
      return {} if client_hash.nil? || client_hash.empty?
      ret = {}
      full_address = Utils::AddressUtils.split_prefecture_and_other(client_hash["cl_full_address"])
      ret["prefecture_code"] = full_address[:prefecture]&.code
      ret["address"] = full_address[:address]
      # その他もcl_を取る
      ret["daihyo_name"] = client_hash["cl_daihyo_name"]
      ret["company_name"] = client_hash["cl_company_name"]
      ret["taxagency_corporate_number"] = client_hash["cl_taxagency_corporate_number"]
      ret["tel"] = client_hash["cl_tel"]
      ret
    end

    def adjust_to_customer_attributes(customer_hash)
      return customer_hash if customer_hash.nil? || customer_hash.empty?
      ret = customer_hash.clone
      full_address = Utils::AddressUtils.split_prefecture_and_other(ret["full_address"])
      ret["prefecture_code"] = full_address[:prefecture]&.code
      ret["address"] = full_address[:address]
      ret.delete("full_address")
      ret
    end

    def adjust_to_exam_attributes(exam_hash)
      return exam_hash if exam_hash.nil? || exam_hash.empty?
      ret = exam_hash.clone
      if (PaymentMethod.find_by_name(ret["payment_method_name"]).present?)
        ret["payment_method_id"] = PaymentMethod.find_by_name(ret["payment_method_name"]).id
      end
      ret["new_transaction"] = (ret["new_transaction_name"] == TRANSACTION_TYPE_NEW)
      ret["payment_delayed"] = (ret["payment_delayed_umu"] == UMU_YES)
      ret["payment_method_changed"] = (ret["payment_method_changed_umu"] == UMU_YES)
      ret.delete("payment_method_name")
      ret.delete("new_transaction_name")
      ret.delete("payment_delayed_umu")
      ret.delete("payment_method_changed_umu")
      ret
    end

    def specify_customer(customer_hash)
      prefecture = Prefecture.find_by_code(customer_hash["prefecture_code"])
      address = Utils::StringUtils::to_zenkaku customer_hash["address"]
      daihyo_name = Utils::StringUtils::to_zenkaku customer_hash["daihyo_name"]
      company_name = Utils::CompanyNameUtils::to_zenkaku_name customer_hash["company_name"]
      taxagency_corporate_number = customer_hash["taxagency_corporate_number"]
      tel = customer_hash["tel"]
      SbGuaranteeCustomer.assign_customer(company_name: company_name, daihyo_name: daihyo_name,
                                          taxagency_corporate_number: taxagency_corporate_number,
                                          prefecture: prefecture, address: address, tel: tel)
    end

    def specify_client(client_hash)
      # 保証元情報がない場合sb_clientの情報を設定する
      if client_hash.nil? || client_hash.values.compact.empty?
        return SbGuaranteeClient.assign_client_myself(@sb_client)
      end
      prefecture = Prefecture.find_by_code(client_hash["prefecture_code"])
      address = Utils::StringUtils::to_zenkaku client_hash["address"]
      daihyo_name = Utils::StringUtils::to_zenkaku client_hash["daihyo_name"]
      company_name = Utils::CompanyNameUtils::to_zenkaku_name client_hash["company_name"]
      taxagency_corporate_number = client_hash["taxagency_corporate_number"]
      tel = client_hash["tel"]
      SbGuaranteeClient.assign_client(@sb_client,
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
