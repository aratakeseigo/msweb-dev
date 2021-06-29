class IdentifyCompanyForm < ApplicationForm
	include Rails.application.routes.url_helpers
	CLASS_ID = { "client" => "1", "exam" => "2", "guarantee" => "3" }
  
	attribute :classification, :string
	attribute :id, :integer
	attribute :company_name, :string
	attribute :daihyo_name, :string
	attribute :zip_code, :string
	attribute :prefecture_code, :string
	attribute :address, :string
	attribute :tel, :string
	attribute :established, :string
	attribute :taxagency_corporate_number, :string
  
	attr_accessor :classification, :id, :company_name, :daihyo_name, :taxagency_corporate_number,
				  :prefecture_code, :address, :daihyo_tel, :established, :zip_code
  
	validates :company_name, presence: true, length: { maximum: 255 }
	validates :daihyo_name, presence: true, length: { maximum: 255 }, user_name: true
	validates :zip_code, allow_blank: true, zip_code: true
	validates :address, allow_blank: true, length: { maximum: 255 }
	validates :daihyo_tel, allow_blank: true, tel: true
	validates :established, allow_blank: true, yyyymm: true
	validates :taxagency_corporate_number, allow_blank: true, taxagency_corporate_number: true
  
	def self.init(classification, params)
	  case classification
	  when CLASS_ID["client"]
		return IdentifyCompanyForm::Client.new(params)
	  when CLASS_ID["exam"]
		return IdentifyCompanyForm::Exam.new(params)
	  when CLASS_ID["guarantee"]
		return IdentifyCompanyForm::Guarantee.new(params)
	  else
		raise StandardError.new("request error")
	  end
	end
  
	def redirect_path
	  raise StandardError.new("サブクラスで実装してください")
	end
  
	def path #画面に合わせるためで本来は不要
	  redirect_path
	end
  
	def assign_default_values
	  raise StandardError.new("サブクラスで実装してください")
	end
  
	def assign_entity(_entity)
	  raise StandardError.new("サブクラスで実装してください")
	  
	end
  
	def create_entity
	  entity_prefecture = Prefecture.find_by_code self.prefecture_code if self.prefecture_code.present?
	  entity = Entity.create_entity(company_name: self.company_name, daihyo_name: self.daihyo_name,
									taxagency_corporate_number: self.taxagency_corporate_number,
									address: self.address, daihyo_tel: self.daihyo_tel, established: self.established,
									zip_code: self.zip_code, prefecture: entity_prefecture)
	  entity.save!
	  assign_entity(entity)
	end
  
	def recommend_entities
	  Entity.select_by_company_no_or_company_name_or_daihyo_name_or(
		company_name: self.company_name,
		daihyo_name: self.daihyo_name,
		taxagency_corporate_number: self.taxagency_corporate_number,
	  )
	end
end
  
class IdentifyCompanyForm::Client < IdentifyCompanyForm
	def assign_default_values
	  sb_client = SbClient.find(id)
	  self.company_name = sb_client.name
	  self.daihyo_name = sb_client.daihyo_name
	  self.taxagency_corporate_number = sb_client.taxagency_corporate_number
	  self.prefecture_code = sb_client.prefecture_code
	  self.address = sb_client.address
	  self.daihyo_tel = sb_client.tel
	  self.established = sb_client.established_in
	  self.zip_code = sb_client.zip_code
	end
  
	def assign_entity(entity)
	  sb_client = SbClient.find(id)
	  sb_client.update(status: Status::ClientStatus::READY_FOR_EXAM, entity: entity)
	end
  
	def redirect_path
	  clients_list_path
	end
end
  
class IdentifyCompanyForm::Exam < IdentifyCompanyForm
end
  
class IdentifyCompanyForm::Guarantee < IdentifyCompanyForm
end