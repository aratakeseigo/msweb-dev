class ApplicationController < ActionController::Base
  before_action :authenticate_internal_user!
  add_flash_types :success, :info, :warning, :danger

  def output_error(e)
    logger.error(e) if e.present?
    if e.present? and e.backtrace.present?
      logger.error e.backtrace.join("\\n").gsub("\t", "\\t")
      if Rails.env.development?
        puts e.backtrace.join("\\n")
      end
    end
  end
end
