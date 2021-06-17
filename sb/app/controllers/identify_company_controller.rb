class IdentifyCompanyController < ApplicationController
    def index
        if "1".eql?(params[:classification]) then
            # クライアント一覧からの起動
            @identify_company = SbClient.find(params[:id])
        else
            # 審査一覧からの起動
            # @identify_company = XXXXXX.find(params[:id])
        end
        @entities = Entity.select_by_company_no_or_company_name_or_daihyo_name_or(
            taxagency_corporate_number: @identify_company.taxagency_corporate_number,
            company_name: @identify_company.name, daihyo_name: @identify_company.daihyo_name)
    end

    def update
        if "1".eql?(params[:classification]) then
            # クライアント一覧からの起動
            @sb_client = SbClient.find(params[:id])
            @sb_client.update( status_id: 2, entity_id: params[:entity_id])
            redirect_to clients_list_path
        else
            # 審査一覧からの起動
            # @identify_company = XXXXXX.find(params[:id])
            # @XXXXXX.update( status_id: 2, entity_id: params[:entity_id])
            # redirect_to clients_list_path
        end
    end
end
