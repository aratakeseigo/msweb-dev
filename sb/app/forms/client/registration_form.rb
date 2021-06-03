module Client
  class RegistrationForm < ApplicationForm
    attribute :area_name, :string
    attribute :tanto_name, :string
    attribute :name, :string
    attribute :daihyo_name, :string
    attribute :zip_code, :string
    attribute :address, :string
    attribute :tel, :string
    attribute :industry_name1, :string
    attribute :industry_name2, :string
    attribute :channel_name, :string
    attribute :agent_name, :string

    attr_accessor :users

    validate :industory_valid?
    validate :area_valid?
    validate :channel_valid?
    validate :agent_valid?
    validate :users_valid?

    def users_valid?
      users.each.with_index(1) do |user, index|
        puts user["email"]
        unless user["email"] =~ Devise.email_regexp
          errors.add(:base, :invalid_email_address, { index: index, email: user["email"] })
        end
      end
    end

    def industory_valid?
      unless Industry.find_by_name industry_name1
        errors.add(:industry_name1, :not_in_master)
      end
      unless Industry.find_by_name industry_name1
        errors.add(:industry_name2, :not_in_master)
      end
    end

    def area_valid?
      unless Area.find_by_name area_name
        errors.add(:area_name, :not_in_master)
      end
    end

    def channel_valid?
      unless Channel.find_by_name channel_name
        errors.add(:channel_name, :not_in_master)
      end
    end

    def agent_valid?
      unless SbAgent.find_by_name agent_name
        errors.add(:agent_name, :not_in_master)
      end
    end

    def self.initFromFile(file)
      column_mapping = {
        "エリア" => "area_name",
        "ＳＢ担当名" => "tanto_name",
        "クライアント名" => "name",
        "代表者名" => "daihyo_name",
        "〒" => "zip_code",
        "住所1" => "address",
        "ＴＥＬ" => "tel",
        "業種1" => "industry_name1",
        "業種2" => "industry_name2",
        "媒体" => "channel_name",
        "代理店" => "agent_name",
        "担当者名" => "name",
        "担当者名カナ" => "name_kana",
        "メールアドレス" => "email",
        "役職" => "position",
        "部署" => "department",
        "希望連絡先" => "contact_tel",
      }
      client_hash_list = Utils::ExcelUtils.excel_to_h(file,
                                                      worksheet_index: 1,
                                                      header_row_index: 1,
                                                      list_start_row_index: 2,
                                                      start_col_index: 1,
                                                      end_col_index: 30,
                                                      header_mapping: column_mapping)

      form = Client::RegistrationForm.new(
        client_hash_list.first.slice(
          "area_name", "tanto_name", "name", "daihyo_name", "zip_code",
          "tel", "industry_name1" "industry_name2", "channel_name", "agent_name"
        )
      )
      client_hash_list.each do |h|
        form.add_user(
          h.slice(
            "name", "name_kana", "email", "position", "department", "contact_tel"
          )
        )
      end
      form
    end

    def add_user(hash)
      @users = [] unless @users

      @users << hash
    end
  end
end
