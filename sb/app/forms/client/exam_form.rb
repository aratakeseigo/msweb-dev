module Client
  class ExamForm < ApplicationForm
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

    validate :sb_client_validate?

    attr_accessor :sb_client, :registration_form_file, :other_files, :current_user

    ## 定数 ##
    MAX_OTHER_FILES_COUNT = 5

    def initialize(attributes, sb_client)
      @sb_client = sb_client
      if attributes.present?
        super(attributes)
      end
    end

    def save_client
      if registration_form_file.present?
        @sb_client.registration_form_file = registration_form_file
      end
      if other_files.present?
        @sb_client.other_files = other_files
      end

      @sb_client.save!

    end

    def sb_client_validate?
      to_sb_client
      unless sb_client.valid?
        sb_client.errors.each do |attr, error|
          errors.add(attr, error)
        end
      end
    end

    def other_files_invalid?
      current_files_count = @sb_client.other_files.size
      if other_files.present?
        input_other_files_count = other_files.size
        if current_files_count + input_other_files_count > MAX_OTHER_FILES_COUNT
          errors.add(:other_files, "は5件までしか保存できません")
          return true
        end
      end
      return false
    end

    def to_sb_client
      @sb_client.area_id = area_id
      @sb_client.sb_tanto_id = sb_tanto_id
      @sb_client.name = name
      @sb_client.daihyo_name = daihyo_name.present? ? (Utils::StringUtils.to_zenkaku daihyo_name) : daihyo_name
      @sb_client.zip_code = zip_code
      @sb_client.prefecture_code = prefecture_code
      @sb_client.address = address
      @sb_client.tel = tel
      @sb_client.industry_id = industry_id
      @sb_client.industry_optional = industry_optional
      @sb_client.established_in = established_in
      @sb_client.annual_sales = annual_sales
      @sb_client.capital = capital
      @sb_client.updated_user = @current_user
    end

    ## 保存しないので常にtrue(rspec用)
    def save!
      return true
    end

  end
end