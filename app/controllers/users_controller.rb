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
    user_params = params[:user]
    @user = User.where(:email => user_params[:email]).first

    #Current user changing password, email
    if current_user.email == user_params[:email]

      #Basic Input Validation
      if user_params[:old_password] != "" &&  user_params[:new_password] != "" && user_params[:confirm_password] != ""

        #Update Password
        if current_user.update_password(user_params[:old_password], user_params[:new_password], user_params[:confirm_password])
          redirect_to(user_path, :notice => 'Password was successfully updated.')
          @user.update_attribute(:email, user_params[:email])
          @user.update_attribute(:notification, user_params[:notification].to_i)
        else
          redirect_to( edit_user_path(current_user), :alert => 'New passwords do not match.')
        end
      end
    else

      #Administrator Changing users password, email
      if (current_user.role == 1 && @user != nil) || User.authenticate(user_params[:email], user_params[:old_password]).present?
        @user.update_attribute(:email, user_params[:email])
        @user.update_attribute(:notification, user_params[:notification].to_i)

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
