class Clients::RegistrationController < ApplicationController
  def index
  end

  def upload
    begin
      @form = Client::RegistrationForm.initFromFile(upload_params[:input_file].tempfile)

      @form.current_user = current_internal_user
      if @form.invalid?
        render :index and return
      end
    rescue ArgumentError => e
      @form = Client::RegistrationForm.new
      @form.errors.add(:base, e.message)
      render :index
    end
  end

  def create
    hash = JSON.parse(create_params[:registration_form])
    users_hash = JSON.parse(create_params[:registration_form_users])
    hash["users"] = users_hash
    @form = Client::RegistrationForm.new(hash)
    @form.current_user = current_internal_user
    if @form.invalid?
      render :index and return
    end
    @form.save_client
    flash[:success] = "登録が完了しました。"
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
