class IdentifyCompanyController < ApplicationController
    def index
        @identify_company = SbClient.find(params[:id])
        @entities = Entity.all.page(params[:page]).per(10)
    end
end
