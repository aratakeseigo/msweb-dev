class IdentifyCompanyController < ApplicationController
    def index
        @identify_company = IdentifyCompanyForm.init(classification: params[:classification], id: params[:id])
        @identify_company.redirect_path(redirect_path: params[:path])
        @entities = Entity.select_by_company_no_or_company_name_or_daihyo_name_or(
            taxagency_corporate_number: @identify_company.taxagency_corporate_number,
            company_name: @identify_company.company_name, daihyo_name: @identify_company.daihyo_name)
    end

    def update
        IdentifyCompanyForm.update_status_and_entity(classification: params[:classification], id: params[:id], entity_id: params[:entity_id] )
        redirect_to params[:path]
    end

    def new_entity
        @identify_company = IdentifyCompanyForm.init(classification: params[:classification], id: params[:id])
        @identify_company.redirect_path(redirect_path: params[:path])
    end

    def create_entity
        @identify_company = IdentifyCompanyForm.new(classification: params[:classification], id: params[:id], company_name: params[:company_name],
             daihyo_name: params[:daihyo_name], zip_code: params[:zip_code], prefecture_code: params[:prefecture_code],
             address: params[:address], daihyo_tel: params[:daihyo_tel], taxagency_corporate_number: params[:taxagency_corporate_number],
             established: params[:established],path: params[:path])
        if @identify_company.invalid?
            respond_to do |format|
                format.html { render :new }
                format.json { render json: @identify_company }
                format.js { @status = "fail" }
            end
        else
            @identify_company.create_entity
            redirect_to params[:path]
        end
    end
end
