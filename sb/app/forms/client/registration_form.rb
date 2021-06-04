module Client
  class RegistrationForm < ApplicationForm
    attribute :name, :string
    attribute :daihyo_name, :string
    attribute :zip_code, :string
    attribute :prefecture, :string
    attribute :address, :string
    attribute :tel, :string
    attribute :industry_name, :string
    attribute :industry_optional, :string
    attribute :established_in, :string
    attribute :capital, :integer

    attr_accessor :users

    validates :prefecture, presence: true, inclusion: { in: Prefecture.all.map(&:name), message: :not_in_master }
    validates :industry_name, presence: true, inclusion: { in: Industry.all.map(&:name), message: :not_in_master }
    validates :users_valid?

    def users_valid?
      users.each.with_index(1) do |user, index|
        unless user["email"] =~ Devise.email_regexp
          errors.add(:base, :invalid_user_email_address, { index: index, email: user["email"] })
        end
      end
    end

    def industory_valid?
      unless Industry.find_by_name industry_name1
        errors.add(:industry_name1, :not_in_master)
      end
    end

    def self.initFromFile(file)
      company_column_mapping = {
        "クライアント名" => "name",
        "代表者名" => "daihyo_name",
        "〒" => "zip_code",
        "都道府県" => "prefecture_name",
        "住所" => "address",
        "ＴＥＬ" => "tel",
        "業種1" => "industry_name",
        "業種2" => "industry_optional",
        "設立" => "established_in",
        "資本金" => "capital",
        "年商（千円）" => "annual_sales",

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
                                                      worksheet_index: 1,
                                                      header_row_index: 1,
                                                      list_start_row_index: 2,
                                                      start_col_index: 1,
                                                      end_col_index: 30,
                                                      header_mapping: column_mapping)

      form = Client::RegistrationForm.new(
        client_hash_list.first.slice(company_column_mapping.values)
      )
      client_hash_list.each do |h|
        form.add_user(h.slice(user_column_mapping.values))
      end
      form
    end

    def add_user(hash)
      @users = [] unless @users

      @users << hash
    end
  end
end
