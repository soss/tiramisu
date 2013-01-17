class UsersController < ApplicationController
  before_filter :require_login, :except => [:new, :create]
  def new
    @user = User.new
  end

  def update
    @user = User.find_by_username(params[:username])
    if current_user == @user
      if @user.change_password!(params[:user][:password])
        redirect_to(root_path, :notice => 'Password was successfully updated.')
      end
    else
      render :action => "edit", :notice => 'Login as user.'
    end
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
