class IdentifyCompanyController < ApplicationController
    before_action :assign_identify_company
  
    def index
      @identify_company.assign_default_values
      @entities = @identify_company.recommend_entities
    end
  
    def update
      @identify_company.assign_entity(Entity.find params[:entity_id])
      redirect_to @identify_company.redirect_path
    end
  
    def new_entity
      @identify_company.assign_default_values
      respond_to do |format|
        format.js
      end
    end
  
    def create_entity
      if @identify_company.invalid?
        @status = "fail"
        render fomat: :js
      else
        @identify_company.create_entity
        @status = "success"
        render fomat: :js
      end
    end
  
    private
  
    def assign_identify_company
      @identify_company = IdentifyCompanyForm.init(form_params[:classification], form_params)
    end
  
    def form_params
      params.permit(:classification, :id, :company_name,
                    :daihyo_name, :zip_code, :prefecture_code,
                    :address, :daihyo_tel, :taxagency_corporate_number,
                    :established)
    end
end