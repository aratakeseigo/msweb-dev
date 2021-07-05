class Clients::RegistrationGuaranteesController < ApplicationController
  before_action :assign_client

  def index
  end

  def upload
    begin
      @form = Guarantee::RegistrationForm.initFromFile(@sb_client,
                                                       current_internal_user,
                                                       upload_params[:input_file])
      if @form.invalid?
        render :index
        return
      end
    rescue ArgumentError => e
      @form = Guarantee::RegistrationForm.new(@sb_client,
                                              current_internal_user,
                                              nil)
      @form.errors.add(:base, e.message)
      render :index
    end
  end

  def create
    begin
      @form = Guarantee::RegistrationForm.initFromGuaranteeRequestId(@sb_client,
                                                                     current_internal_user,
                                                                     create_params[:guarantee_request_id])
      if @form.invalid?
        render :index
        return
      end
      # @form.save_guarantees
      flash[:success] = "保証依頼の登録が完了しました。"
      redirect_to exams_path
    rescue ArgumentError => e
      @form = Guarantee::RegistrationForm.new(@sb_client,
                                              current_internal_user,
                                              nil)
      @form.errors.add(:base, e.message)
      render :index
    end
  end

  private

  def assign_client
    @sb_client = SbClient.find(params[:id])
  end

  def upload_params
    params.permit(:input_file)
  end

  def create_params
    params.permit(:guarantee_request_id)
  end
end
