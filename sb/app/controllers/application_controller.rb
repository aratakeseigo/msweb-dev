class ApplicationController < ActionController::Base
  before_action :authenticate_internal_user!
  before_action :has_sb_permittion!
  add_flash_types :success, :info, :warning, :danger

  def has_sb_permittion!
    return if current_internal_user.nil?
    unless current_internal_user.is_sb_user?
      sign_out current_internal_user
      return
    end
  end

  def output_error(e)
    logger.error(e) if e.present?
    if e.present? and e.backtrace.present?
      logger.error e.backtrace.join("\\n").gsub("\t", "\\t")
      if Rails.env.development?
        puts e.message
        puts e.backtrace.join("\\n")
      end
    end
  end
end
