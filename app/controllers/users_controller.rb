class UsersController < ApplicationController
  before_filter :require_login, :only => [:update, :edit]
  before_filter :admin_only, :only => [:index, :destroy]

  def new
    @user = User.new
  end

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.where(:email => params[:user][:email]).first
    #Current user changing password, email, 

    if current_user.email == params[:user][:email]
      if params[:user][:old_password] != "" &&  params[:user][:new_password] != "" && params[:user][:confirm_password] != ""
        if current_user.update_password(params[:user][:old_password], params[:user][:new_password], params[:user][:confirm_password])
          redirect_to(user_path, :notice => 'Password was successfully updated.')
        else
          redirect_to( edit_user_path(current_user), :alert => 'New passwords do not match.')
        end
      else
        @user.update_attribute(:email, params[:user][:email])
        @user.update_attribute(:notification, params[:user][:notification].to_i)

        redirect_to( root_url, :notice => "Settings changed")
      end
    else
      if (current_user.role == 1 && @user != nil) || User.authenticate(params[:user][:email], params[:user][:old_password]).present?
        @user.update_attribute(:email, params[:user][:email])
        @user.update_attribute(:notification, params[:user][:notification].to_i)

        redirect_to( root_url, :notice => "Settings changed")
      else
        redirect_to( edit_user_path(@user), :notice => 'Login as user or an Administrator.')
      end
    end
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      auto_login(@user, should_remember=false) 
      redirect_to root_url, :notice => "Signed, Up!"
    else
      render :new
    end
  end

  def destroy
    @user = User.find(params[:id])

    if @user.role != 1 && @user.destroy
      redirect_to users_path, :notice => 'User destroyed'
    else
      redirect_to users_path, :alert => 'Could not destroy user'
    end
  end
end
