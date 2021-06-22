class Clients::RegistrationExamsController < ApplicationController
  def index
  end

  def upload
    begin
      puts sss
      @form = Exam::RegistrationForm.initFromFile(SbClient.find(params[:id]), current_internal_user, upload_params[:input_file].tempfile)
      p @form
      if @form.invalid?
        render :index and return
      end
    rescue ArgumentError => e
      @form
      output_error(e)
      @form = Exam::RegistrationForm.new
      @form.errors.add(:base, e.message)
      render :index
    end
  end

  def create
    hash = JSON.parse(create_params[:registration_form])
    users_hash = JSON.parse(create_params[:registration_form_users])
    hash["users"] = users_hash
    @form = Exam::RegistrationForm.new(hash)
    @form.assign_entity
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
