class ApplicationController < ActionController::Base
  before_action :authenticate_internal_user!
end
