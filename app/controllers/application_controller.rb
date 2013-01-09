class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def not_authenticated
  	redirect_to login_url, :alert => "You must be logged in to view this page."
  end
end
