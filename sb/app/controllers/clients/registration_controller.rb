class Clients::RegistrationController < ApplicationController
  def index
  end

  def upload
    @form = Client::RegistrationForm.initFromFile(upload_params[:input_file])
    @form.create_user = current_internal_user
    if @form.invalid?
      render :index and return
    end
  end

  def create
    hash = JSON.parse(create_params[:registration_form])
    users_hash = JSON.parse(create_params[:registration_form_users])
    hash["users"] = users_hash
    @form = Client::RegistrationForm.new(hash)
    @form.create_user = current_internal_user
    @form.save_client
    flash[:notice] = "登録が完了しました。"
    redirect_to clients_list_path
  end

  private

  def upload_params
    params.permit(:input_file)
  end

  def create_params
    params.permit(:registration_form, :registration_form_users)
  end
end
