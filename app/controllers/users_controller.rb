class UsersController < ApplicationController
  def new
  	@user = User.new
  end

  def projects
    @user = User.find_by_username(params[:username])
    @projects = @user.projects
  end

  def create
  	user = User.new(params[:user])
  	if user.save
      auto_login(user, should_remember=false) 
  		redirect_to root_url, :notice => "Signed, Up!"
  	else
  		render :new
  	end
  end
end
