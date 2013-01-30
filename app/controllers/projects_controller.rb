class ProjectsController < ApplicationController
  before_filter :require_login, :except => [:index, :show]
  before_filter :admin_only, :only => [:moderate, :approve]
  before_filter :must_be_creator, :only => [:edit, :update, :destroy]

  def index
    @projects = Project.where(:approved => true)
  end

  def moderate
    @projects = Project.where(:approved => false)

    render 'index'
  end

  def approve
    @project = Project.find(params[:id])
    @project.approved = true
    @project.save

    redirect_to @project, :notice => 'Project has been approved!'
  end

  def show
    @project = Project.find(params[:id])
    unless current_user_admin? || @project.approved
      redirect_to projects_path, :alert => 'That project is not quite ready for the spotlight'
    end
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(params[:project])
    @project.user = current_user

    if @project.save
      # create a vote
      @project.votes.create(:user_id => current_user.id)

      # create a pledge
      @project.pledges.create(:user_id => current_user.id)

      redirect_to root_url, :notice => "Got it! Your entry is currently waiting approval"
    else
      render :new, :alert => "An error ocurred while creating the Project"
    end
  end

  def edit
    @project = Project.find(params[:id])  
  end

  def update
    @project = Project.find(params[:id])
    if @project.update_attributes(params[:project])
      redirect_to @project, :notice => "Project updated successfully"
    else
      redirect_to @project, :alert => "An error ocurred while updating the Project"
    end
  end

  def destroy
    @project = Project.find(params[:id])
    if @project.destroy
      redirect_to root_url, :notice => "Project destroyed"
    else
      redirect_to @project, :alert => "An error ocurred while deleting the Project"
    end
  end

  def promote
    @project = Project.find(params[:id])
    @project.votes.create(:user_id => current_user.id)

    @points = @project.votes.count

    render 'promote.js'
  end

  def pledge
    @project = Project.find(params[:id])
    
    unless @project.pledges.where(:user_id => current_user).any?
      @project.pledges.create(:user_id => current_user.id)
      render 'pledge.js'
    else
      render :js => 'console.log("ha!")'
    end
  end

  def leave
    @project = Project.find(params[:id])
    if @project.pledges.where(:user_id => current_user).first.try(:destroy)
      render 'leave.js'
    else
      render :js => 'console.log("ha!")'
    end
  end

  private

  def must_be_creator
    return if current_user_admin?
    @project = Project.find(params[:id]) # notice how we set @project here, and don't need to do it later
    redirect_to @project, :alert => "Access Denied" unless @project.user == current_user
  end
end
