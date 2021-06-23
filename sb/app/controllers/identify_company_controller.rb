class IdentifyCompanyController < ApplicationController
    def index
        @identify_company = IdentifyCompanyForm.init(params[:classification], params[:id])
        @identify_company.redirect_path(params[:path])
        @entities = Entity.select_by_company_no_or_company_name_or_daihyo_name_or(
            taxagency_corporate_number: @identify_company.taxagency_corporate_number,
            company_name: @identify_company.company_name, daihyo_name: @identify_company.daihyo_name)
        logger.debug(@identify_company)
    end

    def update
        IdentifyCompanyForm.update_status( params[:classification], params[:id], params[:entity_id] )
        redirect_to params[:path]
    end

    def new_entity
        @identify_company = IdentifyCompanyForm.init(params[:classification], params[:id])
=begin
        @entity = Entity.create_entity(company_name: @identify_company.company_name, daihyo_name: @identify_company.daihyo_name,
            taxagency_corporate_number: @identify_company.taxagency_corporate_number,
            prefecture: @identify_company.prefecture_code, address: @identify_company.address,
            daihyo_tel: @identify_company.daihyo_tel,
            established: @identify_company.established,
            zip_code: @identify_company.zip_code)
=end
        @entity = Entity.new(corporation_number: @identify_company.taxagency_corporate_number, established: @identify_company.established)
        @entity.build_entity_profile(corporation_name: @identify_company.company_name, daihyo_name: @identify_company.daihyo_name,
            address: @identify_company.address, daihyo_tel: @identify_company.daihyo_tel, zip_code: @identify_company.zip_code,
            prefecture_code: @identify_company.prefecture_code)
end

    def create_entity
        respond_to do |format|
            if !@entity.nil?
                format.html { redirect_to @user, notice: 'User was successfully created.' }
                format.json { render :show, status: :created, location: @user }
                format.js { @status = "success"}
            else
                format.html { render :new }
                format.json { render json: @entity.errors, status: :unprocessable_entity }
                format.js { @status = "fail" }
            end
        end
    end
end
