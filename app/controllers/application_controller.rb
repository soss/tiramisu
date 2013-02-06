class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :load_moderation_count

  helper_method :current_user_admin?

  def current_user_admin?
    current_user && current_user.role == 1
  end

  def admin_only
    unless current_user_admin?
      redirect_to root_url, :alert => "You do not have access to this page"
    end
  end

  private

  def not_authenticated
  	redirect_to login_url, :alert => "You must be logged in to view this page."
  end

  def load_moderation_count
    return unless current_user_admin?
    @moderation_count = Project.where(:approved => false).count
  end
end
