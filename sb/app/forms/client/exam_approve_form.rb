module Client
  class ExamApproveForm < ApplicationForm
    attribute :area_id, :integer
    attribute :sb_tanto_id, :integer
    attribute :name, :string
    attribute :daihyo_name, :string
    attribute :zip_code, :string
    attribute :prefecture_code, :integer
    attribute :address, :string
    attribute :tel, :string
    attribute :industry_id, :integer
    attribute :industry_optional, :string
    attribute :established_in, :string
    attribute :annual_sales, :integer
    attribute :capital, :integer
    attribute :ab_info, :string
    attribute :bl_info, :string
    attribute :by_info, :string
    attribute :exam_info, :string
    attribute :guarantee_info, :string
    attribute :tsr_score, :string
    attribute :tdb_score, :string
    attribute :anti_social, :boolean
    attribute :anti_social_memo, :string
    attribute :reject_reason, :string
    attribute :communicate_memo, :string

    validate :sb_client_validate?

    attr_accessor :area_id, 
                  :sb_tanto_id,
                  :name,
                  :daihyo_name,
                  :zip_code,
                  :prefecture_code,
                  :address,
                  :tel,
                  :industry_id,
                  :industry_optional,
                  :established_in,
                  :annual_sales,
                  :capital,
                  :registration_form_file,
                  :other_files,
                  :output_registration_form_file,
                  :output_other_files,
                  :current_user,
                  :ab_info,
                  :bl_info,
                  :by_info,
                  :exam_info,
                  :guarantee_info,
                  :tsr_score,
                  :tdb_score,
                  :anti_social,
                  :anti_social_memo,
                  :reject_reason,
                  :communicate_memo

    ## 定数 ##
    MAX_OTHER_FILES_COUNT = 5
    EXIST = "あり"
    NOT_EXIST = "なし"

    def initialize(attributes, sb_client)
      @sb_client = sb_client
    
      # formのattirbutesにクライアント情報を設定
      @area_id = @sb_client.area_id
      @sb_tanto_id = @sb_client.sb_tanto_id
      @name = @sb_client.name
      @daihyo_name = @sb_client.daihyo_name
      @zip_code = @sb_client.zip_code
      @prefecture_code = @sb_client.prefecture_code
      @address = @sb_client.address
      @tel = @sb_client.tel
      @industry_id = @sb_client.industry_id
      @industry_optional = @sb_client.industry_optional
      @established_in = @sb_client.established_in
      @annual_sales = @sb_client.annual_sales
      @capital = @sb_client.capital

      # 表示用申込書とファイルを設定
      @output_registration_form_file = @sb_client.registration_form_file
      @output_other_files = @sb_client.other_files

      # sb_client_examが存在する場合、formのattribute,asに詰める
      @sb_client_exam = @sb_client.sb_client_exams.find_by(available_flag: true)
      if @sb_client_exam.present?
        @tsr_score = @sb_client_exam.tsr_score
        @tdb_score = @sb_client_exam.tdb_score
        @anti_social = @sb_client_exam.anti_social
        @anti_social_memo = @sb_client_exam.anti_social_memo
        @reject_reason = @sb_client_exam.reject_reason
        @communicate_memo = @sb_client_exam.communicate_memo
      end

      # entityが存在する場合
      if @sb_client.entity.present?
        search_infos(@sb_client.entity.house_company_code)
      end

      # 決裁、差戻しの場合
      # if attributes.present?
      #   super(attributes)
      # end
    end

    def search_infos(house_company_code)
      ab_info = CustomerMaster.where(house_company_code: house_company_code).exists?
      bl_info = AccsBlInfo.where(corporate_code: house_company_code).exists?
      exam_info = SbGuaranteeExam.joins(sb_guarantee_customer: :entity).where(entities:{house_company_code: house_company_code}).exists?
      by_info = ByCustomer.joins(:entity).where(entities:{house_company_code: house_company_code}).exists?

      @ab_info = ab_info.present? ? EXIST : NOT_EXIST
      @bl_info = bl_info.present? ? EXIST : NOT_EXIST
      @exam_info = exam_info.present? ? EXIST : NOT_EXIST
      @by_info = by_info.present? ? EXIST : NOT_EXIST
      # 保証テーブル作成後に実装
      #@guarantee_info
    end

    ## 保存しないので常にtrue(rspec用)
    def save!
      return true
    end
  end
end