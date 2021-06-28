class IdentifyCompanyForm < ApplicationForm
	CLASS_ID = {"client" => "1", "exam" => "2", "guarantee" => "3"}

	attr_accessor :classification, :id, :company_name,:daihyo_name, :taxagency_corporate_number,
				:prefecture_code, :address, :daihyo_tel, :established, :zip_code, :path

	validates :company_name, presence: true, length: { maximum: 255 }
	validates :daihyo_name, presence: true, length: { maximum: 255 }, user_name: true
	validates :zip_code, allow_blank: true, zip_code: true
	validates :address, allow_blank: true, length: { maximum: 255 }
	validates :daihyo_tel, allow_blank: true, tel: true
	validates :established, allow_blank: true, yyyymm: true
	validates :taxagency_corporate_number, allow_blank: true, taxagency_corporate_number: true
  
	def initialize (classification: nil, id: nil, company_name: nil, daihyo_name: nil, taxagency_corporate_number: nil,
		prefecture_code: nil, address: nil, daihyo_tel: nil, established: nil, zip_code: nil, path: nil)
		self.classification = classification
		self.id = id
		self.company_name = company_name
		self.daihyo_name = daihyo_name
		self.taxagency_corporate_number = taxagency_corporate_number
		self.prefecture_code = prefecture_code
		self.address = address
		self.daihyo_tel = daihyo_tel
		self.established = established
		self.zip_code = zip_code
		self.path = path
	end

	def redirect_path(redirect_path: nil)
		raise StandardError.new("redirect_path")
	end

	def self.init(classification: nil, id: nil)
		case  classification
		when CLASS_ID["client"]
			return IdentifyCompanyForm::Client.new(id: id)
		when CLASS_ID["exam"]
			return IdentifyCompanyForm::Exam.new(id: id)
		when CLASS_ID["guarantee"]
			return IdentifyCompanyForm::Guarantee.new(id: id)
		else
			raise StandardError.new("request error")
		end
	end

	def self.update_status_and_entity(classification: nil, id: nil, entity_id: nil)
		sb_client = SbClient.find(id)
		case  classification
		when CLASS_ID["client"]
			sb_client.update( status_id: Status::ClientStatus::READY_FOR_EXAM.id, entity_id: entity_id)
		when CLASS_ID["exam"]
			sb_client.update( status_id: Status::ClientStatus::READY_FOR_EXAM.id, entity_id: entity_id)
		when CLASS_ID["guarantee"]
			sb_client.update( status_id: Status::GuaranteeStatus::READY_FOR_CONFIRM.id, entity_id: entity_id)
		else
		  raise StandardError.new("request error")
		end
	end

	def create_entity
		entity_prefecture = Prefecture.find_by_id self.prefecture_code if self.prefecture_code.present?
		entity = Entity.create_entity(company_name: self.company_name, daihyo_name: self.daihyo_name,
									taxagency_corporate_number: self.taxagency_corporate_number,
									address: self.address, daihyo_tel: self.daihyo_tel, established: self.established,
									zip_code: self.zip_code, prefecture: entity_prefecture)
		entity.save!

		IdentifyCompanyForm.update_status_and_entity(classification: self.classification, id: self.id, entity_id: entity.id)
	end

end

class IdentifyCompanyForm::Client < IdentifyCompanyForm

	def redirect_path(redirect_path: nil)
			self.path = redirect_path
	end

	def initialize (id: nil)
		sb_client = SbClient.find(id)
		self.classification = 1
		self.id = sb_client.id
		self.company_name = sb_client.name
		self.daihyo_name = sb_client.daihyo_name
		self.taxagency_corporate_number = sb_client.taxagency_corporate_number
		self.prefecture_code = sb_client.prefecture_code
		self.address = sb_client.address
		self.daihyo_tel = sb_client.tel
		self.established = sb_client.established_in
		self.zip_code = sb_client.zip_code
	end
end

class IdentifyCompanyForm::Exam < IdentifyCompanyForm

	def redirect_path(redirect_path: nil)
		self.path = redirect_path
	end

	def initialize (id: nil)
		sb_client = SbClient.find(id)
		self.classification = 1
		self.id = sb_client.id
		self.company_name = sb_client.name
		self.daihyo_name = sb_client.daihyo_name
		self.taxagency_corporate_number = sb_client.taxagency_corporate_number
		self.prefecture_code = sb_client.prefecture_code
		self.address = sb_client.address
		self.daihyo_tel = sb_client.tel
		self.established = sb_client.established_in
		self.zip_code = sb_client.zip_code
	end
end

class IdentifyCompanyForm::Guarantee < IdentifyCompanyForm

	def redirect_path(redirect_path: nil)
		self.path = redirect_path
	end

	def initialize (id: nil)
		sb_client = SbClient.find(id)
		self.classification = 1
		self.id = sb_client.id
		self.company_name = sb_client.name
		self.daihyo_name = sb_client.daihyo_name
		self.taxagency_corporate_number = sb_client.taxagency_corporate_number
		self.prefecture_code = sb_client.prefecture_code
		self.address = sb_client.address
		self.daihyo_tel = sb_client.tel
		self.established = sb_client.established_in
		self.zip_code = sb_client.zip_code
	end
end

