class IdentifyCompanyForm < ApplicationForm
	include Rails.application.routes.url_helpers
  
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
	  when "client" # SBクライアント
		return IdentifyCompanyForm::Client.new(params)
	  when "guarantee_client" # 保証元
		return IdentifyCompanyForm::GuaranteeClient.new(params)
	when "guarantee_customer" # 保証先
		return IdentifyCompanyForm::GuaranteeCustomer.new(params)
	  else
		raise StandardError.new("request error")
	  end
	end
  
	def redirect_path
	  raise StandardError.new("サブクラスで実装してください")
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
	  Entity.select_by_company_name_or_daihyo_name_or_company_no(
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

# 保証元
class IdentifyCompanyForm::GuaranteeClient < IdentifyCompanyForm

	def assign_default_values
		sb_guarantee_exam = SbGuaranteeExam.find(id)
		sb_guarantee_client = sb_guarantee_exam.sb_guarantee_client
		self.company_name = sb_guarantee_client.company_name
		self.daihyo_name = sb_guarantee_client.daihyo_name
		self.taxagency_corporate_number = sb_guarantee_client.taxagency_corporate_number
		self.prefecture_code = sb_guarantee_client.prefecture_code
		self.address = sb_guarantee_client.address
		self.daihyo_tel = sb_guarantee_client.tel
	end

	def redirect_path
	  exams_list_path
	end
  
	def assign_entity(entity)
		exam = SbGuaranteeExam.find(id)
		exam.sb_guarantee_client.update(entity: entity)
		SbGuaranteeExam.joins(:sb_guarantee_customer, :sb_guarantee_client)
			.where(status_id: Status::ExamStatus::COMPANY_NOT_DETECTED.id)
			.where.not(sb_guarantee_clients: {entity_id: nil}, sb_guarantee_customers: {entity_id: nil})
			.update_all(status_id: Status::ExamStatus::READY_FOR_EXAM.id)
	end
end

# 保証先
class IdentifyCompanyForm::GuaranteeCustomer < IdentifyCompanyForm

	def assign_default_values
		sb_guarantee_exam = SbGuaranteeExam.find(id)
		sb_guarantee_customer = sb_guarantee_exam.sb_guarantee_customer
		self.company_name = sb_guarantee_customer.company_name
		self.daihyo_name = sb_guarantee_customer.daihyo_name
		self.taxagency_corporate_number = sb_guarantee_customer.taxagency_corporate_number
		self.prefecture_code = sb_guarantee_customer.prefecture_code
		self.address = sb_guarantee_customer.address
		self.daihyo_tel = sb_guarantee_customer.tel
	end

	def redirect_path
	  exams_list_path
	end
  
	def assign_entity(entity)
		exam = SbGuaranteeExam.find(id)
		exam.sb_guarantee_customer.update(entity: entity)
		SbGuaranteeExam.joins(:sb_guarantee_customer, :sb_guarantee_client)
			.where(status_id: Status::ExamStatus::COMPANY_NOT_DETECTED.id)
			.where.not(sb_guarantee_clients: {entity_id: nil}, sb_guarantee_customers: {entity_id: nil})
			.update_all(status_id: Status::ExamStatus::READY_FOR_EXAM.id)
	end
end
