class ClientsController < ApplicationController
  def list
    @q = SbClient.ransack(params[:q])
    @client = @q.result.includes(:sb_agent).page(params[:page])
  end

  def search
    @q = ByThing.ransack(search_params)
    @client = @q.result.includes(:sb_agent).page(params[:page])
    render :list
  end

  def upload
  end

  private
  def search_params
    params.require(:q).permit(:name_cont, :daihyo_name_cont, :prefecture_code_eq, :address_cont, :created_at_gteq, :created_at_lteq_end_of_day)
  end
end
