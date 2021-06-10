class ClientsController < ApplicationController
  def list
    @q = SbClient.ransack(params[:q])
    @clients = @q.result(distinct: true).includes(:sb_agent, :sb_client_users).page(params[:page]).decorate
  end
end
