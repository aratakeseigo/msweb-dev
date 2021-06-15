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

    attr_accessor :sb_client, :registration_form_file

    def initialize(attributes, sb_client)
      @sb_client = sb_client[:sb_client]
      #@sb_client = sb_client
      if attributes.present?
        super(attributes)
      end
    end

    def save_client
      # sb_client = to_sb_client
      @sb_client.area_id = self.area_id
      @sb_client.sb_tanto_id = sb_tanto_id
      @sb_client.name = name
      @sb_client.daihyo_name = daihyo_name
      @sb_client.zip_code = zip_code
      @sb_client.prefecture_code = prefecture_code
      @sb_client.address = address
      @sb_client.tel = tel
      @sb_client.industry_id = industry_id
      @sb_client.industry_optional = industry_optional
      @sb_client.annual_sales = annual_sales
      @sb_client.capital = capital
      @sb_client.registration_form_file = registration_form_file

      @sb_client.save!

      # sb_client.reload
      # @sb_client = sb_client
    end

    def sb_client_validate?
      sb_client = to_sb_client
      unless sb_client.valid?
        sb_client.errors.each do |attr, error|
          errors.add(attr, error)
        end
      end
    end

    def to_sb_client
      sb_client = SbClient.new
      sb_client.area_id = area_id
      sb_client.sb_tanto_id = sb_tanto_id
      sb_client.name = name
      sb_client.daihyo_name = daihyo_name
      sb_client.zip_code = zip_code
      sb_client.prefecture_code = prefecture_code
      sb_client.address = address
      sb_client.tel = tel
      sb_client.industry_id = industry_id
      sb_client.industry_optional = industry_optional
      sb_client.annual_sales = annual_sales
      sb_client.capital = capital
      sb_client
    end
  end

  # def add_sb_client(hash)
  #   @users = [] unless @users
  #   @users << hash
  # end

end