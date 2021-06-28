module Client
  class RegistrationForm < ApplicationForm
    attribute :company_name, :string
    attribute :daihyo_name, :string
    attribute :zip_code, :string
    attribute :prefecture_name, :string
    attribute :address, :string
    attribute :tel, :string
    attribute :industry_name, :string
    attribute :industry_optional, :string
    attribute :established_in, :date
    attribute :capital, :integer
    attribute :annual_sales, :integer
    attribute :taxagency_corporate_number, :string

    attr_accessor :users, :current_user, :sb_client, :entity, :status, :is_assign_new_entity

    validates :prefecture_name, presence: true, inclusion: { in: Prefecture.all.map(&:name), message: :not_in_master }
    validates :industry_name, presence: true, inclusion: { in: Industry.all.map(&:name), message: :not_in_master }
    validates :users, presence: true
    validate :sb_client_validate?

    # save_clientの前にassign_entityをしておくこと
    def save_client
      sb_client = to_sb_client
      add_client_users(sb_client)
      create_entity if entity.present? and entity.house_company_code.nil?
      sb_client.entity = entity
      sb_client.status = status
      sb_client.sb_tanto = @current_user
      sb_client.save!
      sb_client.reload
      @sb_client = sb_client
    end

    def create_entity
      entity_established = sprintf("%04d-%02d", established_in.year, established_in.mon) if established_in.present?
      entity_prefecture = Prefecture.find_by_name prefecture_name if prefecture_name.present?
      entity = Entity.create_entity(company_name: company_name, daihyo_name: daihyo_name,
                                    taxagency_corporate_number: taxagency_corporate_number,
                                    address: address, daihyo_tel: tel, established: entity_established,
                                    zip_code: zip_code, prefecture: entity_prefecture)
      entity.save!
    end

    def sb_client_validate?
      sb_client = to_sb_client
      unless sb_client.valid?
        sb_client.errors.each do |attr, error|
          errors.add(attr, error)
        end
      end
      add_client_users(sb_client)&.each&.with_index(1) do |user, num|
        unless user.valid?
          user.errors.each do |attr, error|
            errors.add(attr, error + "[#{num}行目]")
          end
        end
      end
    end

    def to_sb_client
      sb_client = SbClient.new
      sb_client.created_user = @current_user
      sb_client.updated_user = @current_user
      sb_client.name = company_name
      sb_client.daihyo_name = Utils::StringUtils.to_zenkaku daihyo_name if daihyo_name.present?
      sb_client.zip_code = zip_code
      sb_client.prefecture = Prefecture.find_by_name prefecture_name if prefecture_name.present?
      sb_client.address = address
      sb_client.tel = tel
      sb_client.taxagency_corporate_number = taxagency_corporate_number
      sb_client.industry = Industry.find_by_name industry_name if industry_name.present?
      sb_client.industry_optional = industry_optional
      sb_client.established_in = sprintf("%04d%02d", established_in.year, established_in.mon) if established_in.present?

      #円で格納( *1000する )
      sb_client.capital = capital * 1000 if capital.present?
      sb_client.annual_sales = annual_sales * 1000 if annual_sales.present?
      sb_client
    end

    def add_client_users(sb_client)
      users&.map do |user_hash|
        user = sb_client.sb_client_users.build
        user.name = user_hash["user_name"]
        user.name_kana = user_hash["user_name_kana"]
        user.contact_tel = user_hash["contact_tel"]
        user.email = user_hash["email"]
        user.position = user_hash["position"]
        user.department = user_hash["department"]
        user
      end
    end

    def self.initFromFile(file)
      company_column_mapping = {
        "クライアント名" => "company_name",
        "代表者名" => "daihyo_name",
        "〒" => "zip_code",
        "都道府県" => "prefecture_name",
        "住所2" => "address",
        "ＴＥＬ" => "tel",
        "業種1" => "industry_name",
        "業種2" => "industry_optional",
        "設立" => "established_in",
        "資本金（千円）" => "capital",
        "年商（千円）" => "annual_sales",
        "法人番号" => "taxagency_corporate_number",
      }
      user_column_mapping = {
        "担当者名" => "user_name",
        "担当者名カナ" => "user_name_kana",
        "メールアドレス" => "email",
        "役職" => "position",
        "部署" => "department",
        "希望連絡先" => "contact_tel",
      }
      column_mapping = company_column_mapping.merge user_column_mapping
      client_hash_list = Utils::ExcelUtils.excel_to_h(file,
                                                      worksheet_index: 0,
                                                      header_row_index: 1,
                                                      list_start_row_index: 2,
                                                      list_end_row_index: 6, #５人まで
                                                      start_col_index: 0,
                                                      end_col_index: 30,
                                                      header_mapping: column_mapping)

      return form = Client::RegistrationForm.new if client_hash_list.empty?

      form = Client::RegistrationForm.new(
        client_hash_list.first.select { |key| company_column_mapping.values.include? key }
      )
      client_hash_list.each do |h|
        user_hash = h.select { |key| user_column_mapping.values.include? key }
        next if user_hash.values.join.empty?
        form.add_user(user_hash)
      end
      form.assign_entity
      form
    end

    def add_user(hash)
      @users = [] unless @users
      @users << hash
    end

    def assign_entity
      @status = Status::ClientStatus::COMPANY_NOT_DETECTED
      @entity = Entity.assign_entity(company_name: company_name, daihyo_name: daihyo_name,
                                     taxagency_corporate_number: taxagency_corporate_number, address: address)
      if @entity.present?
        @status = Status::ClientStatus::READY_FOR_EXAM
        return @entity
      end
      # 候補がある場合はなにもせず終了
      if Entity.recommend_entity_exists?(company_name: company_name, daihyo_name: daihyo_name,
                                         taxagency_corporate_number: taxagency_corporate_number)
        @entity = nil
        return @entity
      end
      # 全く一致しない場合は作る(この時点では空、save_clientで中身を設定して保存する)
      @entity = Entity.new
      @status = Status::ClientStatus::READY_FOR_EXAM
      @entity
    end

    ## 保存しないので常にtrue(rspec用)
    def save!
      return true
    end
  end
end
