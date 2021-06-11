class Clients::ExamController < ApplicationController
  def show
    @client = SbClient.find(params[:id])
  end
end