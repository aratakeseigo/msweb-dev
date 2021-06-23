class Clients::RegistrationExamsController < ApplicationController
  before_action :assign_client

  def index
  end

  def upload
    begin
      @form = Exam::RegistrationForm.initFromFile(@sb_client,
                                                  current_internal_user,
                                                  upload_params[:input_file].tempfile)
      if @form.invalid?
        render :index and return
      end
    rescue ArgumentError => e
      @form
      @form = Exam::RegistrationForm.new(@sb_client,
                                         current_internal_user,
                                         nil)
      @form.errors.add(:base, e.message)
      render :index
    end
  end

  def create
    @form = Exam::RegistrationForm.initFromSavedFile(@sb_client,
                                                     current_internal_user,
                                                     upload_params[:input_file].tempfile)
    if @form.invalid?
      render :index and return
    end
    @form.save_exams
    flash[:success] = "保証審査の登録が完了しました。"
    redirect_to exam_list_path
  end

  private

  def assign_client
    @sb_client = SbClient.find(params[:id])
  end

  def upload_params
    params.permit(:input_file)
  end

  def create_params
    params.permit(:registration_form, :registration_form_users)
  end
end
