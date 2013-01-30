class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user_admin?

  def current_user_admin?
    current_user && current_user.role == 1
  end

  private

  def not_authenticated
  	redirect_to login_url, :alert => "You must be logged in to view this page."
  end
end
