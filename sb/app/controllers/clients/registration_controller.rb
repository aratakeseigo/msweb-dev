class Clients::RegistrationController < ApplicationController
  def index
  end

  def upload
    @form = Client::RegistrationForm.initFromFile(upload_params[:input_file])
  end

  def create
    @form = Client::RegistrationForm.new(JSON.parse(create_params[:registration_form]))
    puts @form.to_json
    puts @form.valid?
    puts @form.errors.full_messages
    redirect_to clients_list_path
  end

  private

  def upload_params
    params.permit(:input_file)
  end

  def create_params
    params.permit(:registration_form)
  end
end
