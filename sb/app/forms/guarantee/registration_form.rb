module Guarantee
  class RegistrationForm < ApplicationForm
    attr_accessor :guarantees, :sb_guarantee_request

    validate :guarantees_validate?

    # 保証審査IDから初期化する（create時に使用）
    def self.initFromGuaranteeRequestId(sb_client, current_user, id)
      begin
        sb_guarantee_request = sb_client.sb_guarantee_requests.find(id)

        # 保証審査依頼からファイルを取得して読み込み処理を呼び出す
        Utils::ActiveStorageFileOpener.new(sb_guarantee_request.guarantee_request_file).open do |file|
          initFromGuaranteeRequest(sb_client, current_user, sb_guarantee_request, file)
        end
      rescue ActiveRecord::RecordNotFound
        # 保証審査依頼IDが見つからなかった場合
        raise ArgumentError.new("不正な操作です。ファイルアップロードからやり直してください。" +
                                "(CLIENT_ID:#{sb_client.id},REQUEST_ID:#{id})")
      end
    end

    # 保証審査依頼ファイルから初期化する（upload時に使用）
    def self.initFromFile(sb_client, current_user, upload_file)

      # 保証審査依頼を作成してファイルを添付する
      sb_guarantee_request = sb_client.sb_guarantee_requests.create(
        created_user: current_user,
      )
      sb_guarantee_request.save
      sb_guarantee_request.guarantee_request_file.attach upload_file
      # ファイル読み込み処理を呼び出す
      initFromGuaranteeRequest(sb_client, current_user, sb_guarantee_request, upload_file.tempfile)
    end

    # 共通のファイル読み込み処理
    def self.initFromGuaranteeRequest(sb_client, current_user, sb_guarantee_request, file)
      column_mapping = {
        "顧客管理番号" => "exam_search_key",
        "法人名(保証元)" => "client_company_name",
        "代表者名(保証元)" => "client_daihyo_name",
        "法人名" => "company_name",
        "代表者名" => "daihyo_name",
        "保証開始日" => "guarantee_start_at",
        "保証終了日" => "guarantee_end_at",
        "保証依頼額" => "guarantee_amount_hope",
      }
      guarantee_request_hash_list = Utils::ExcelUtils.excel_to_h(file,
                                                                 worksheet_index: 0,
                                                                 header_row_index: 1,
                                                                 list_start_row_index: 3,
                                                                 list_end_row_index: 204, #200件まで
                                                                 start_col_index: 0,
                                                                 end_col_index: 30,
                                                                 header_mapping: column_mapping)
      form = Guarantee::RegistrationForm.new(sb_client, current_user, sb_guarantee_request)

      guarantee_request_hash_list.each do |h|
        next if h.values.join.blank?
        form.add_guarantee(h)
      end
      form
    end

    def initialize(sb_client, current_user, sb_guarantee_request)
      @sb_client = sb_client
      @current_user = current_user
      @sb_guarantee_request = sb_guarantee_request
    end

    def client_name
      @sb_client.name
    end

    def save_guarantees
      guarantees.each do |guarantee|
        # # 再度特定する
        # # 同じファイルに同じ保証元、保証先がいた場合に再利用するため
        # sbg_client = specify_client(exam.sb_guarantee_client.attributes)
        # sbg_customer = specify_customer(exam.sb_guarantee_customer.attributes)

        # # それぞれ既存（保存済み）でなければ作成ユーザーを設定
        # sbg_client.created_user = @current_user unless sbg_client.persisted?
        # sbg_customer.created_user = @current_user unless sbg_customer.persisted?

        # exam.sb_guarantee_client = sbg_client
        # exam.sb_guarantee_customer = sbg_customer
        # if sbg_client.entity.present? and sbg_customer.entity.present?
        #   exam.status = Status::ExamStatus::READY_FOR_EXAM
        # else
        #   exam.status = Status::ExamStatus::COMPANY_NOT_DETECTED
        # end
        # exam.created_user = @current_user
        # exam.save!
      end
      guarantees
    end

    def guarantees_validate?
      if guarantees.nil? || guarantees.empty?
        errors.add(:guarantees, :not_empty)
        return
      end
      guarantees.each.with_index(1) do |guarantee, num|
        if guarantee.sb_guarantee_exam.nil?
          errors.add(:guarantees, "審査が特定できません[#{num}行目] Key:[#{guarantee.exam_search_key}] 保証先名:[#{guarantee.company_name}]")
          next
        end
        if guarantee.company_name != guarantee.sb_guarantee_customer.company_name
          errors.add(:guarantees, "特定した審査と法人名が異なります[#{num}行目] Key:[#{guarantee.exam_search_key}] 保証依頼:[#{guarantee.company_name}] 登録済み:[#{guarantee.sb_guarantee_customer.company_name}]")
          next
        end
        unless guarantee.valid?
          guarantee.errors.each do |attr, error|
            errors.add(attr, error + "[#{num}行目]")
          end
        end
      end
    end

    def add_guarantee(guarantee_request_hash)
      @guarantees = [] unless @guarantees.present?
      # 審査を特定する
      exam_search_key = guarantee_request_hash["exam_search_key"]
      sbg_exam = nil
      if exam_search_key.present?
        sbg_exams = @sb_client.sb_guarantee_exams.approved.where(exam_search_key: exam_search_key)
          .joins(:sb_approval).order("approved_at desc")
        # 同じ検索キーで複数該当する場合は最後に承認された審査を採用する
        sbg_exam = sbg_exams.first unless sbg_exams.empty?
      end
      # 保証を作成する
      sbg_guarantee = @sb_client.sb_guarantees.build(
        guarantee_request_hash.merge({
          sb_guarantee_exam: sbg_exam,
          sb_guarantee_customer: sbg_exam&.sb_guarantee_customer,
          sb_guarantee_client: sbg_exam&.sb_guarantee_client,
          sb_guarantee_request: @sb_guarantee_request,
          accepted_at: Time.zone.now,
        })
      )
      set_guarantee_amount(sbg_guarantee)
      @guarantees << sbg_guarantee
      sbg_guarantee
    end

    def set_guarantee_amount(sbg_guarantee)
      # TODO 同じ審査に紐づく現在の保証を検索して受け入れ可能額を決定する
      # とりあえずそのまま設定している
      sbg_guarantee.guarantee_amount = sbg_guarantee.guarantee_amount_hope
    end

    ## 保存しないので常にtrue(rspec用)
    def save!
      return true
    end
  end
end
