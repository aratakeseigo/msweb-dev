class Clients::RegistrationController < ApplicationController
  def index
  end

  def upload
    @form = Client::RegistrationForm.initFromFile(upload_params[:input_file])
  end

  private

  def upload_params
    params.permit(:input_file)
  end
end
