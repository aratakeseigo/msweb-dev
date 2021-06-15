class Clients::ExamController < ApplicationController
  def edit
    load_client
    @form = Client::ExamForm.new(nil, sb_client: @sb_client)
  end

  def update
    load_client
    @form = Client::ExamForm.new(client_params, sb_client: @sb_client)
    if @form.invalid?
      render :edit and return
    end

    @form.save_client
    flash[:success] = "編集が完了しました。"
    redirect_to clients_list_path
  end

  private
  def client_params
    params.permit(:area_id, :sb_tanto_id, :name, :daihyo_name, :zip_code, :zip_code, :prefecture_code, :address, :tel, :industry_id, :industry_optional, :established_in, :annual_sales, :capital, :registration_form_file)
  end

  def load_client
    @sb_client = SbClient.find(params[:id])
  end
end