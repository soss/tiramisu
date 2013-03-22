class ProjectsController < ApplicationController
  before_filter :require_login, :except => [:index, :show]
  before_filter :admin_only, :only => [:edit, :update, :moderate, :approve]
  before_filter :must_be_creator, :only => [:destroy]
  before_filter :prevent_mass_assign, :only => [:create, :update]

  def index
    @projects = Project.sorted_by_votes
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

      # send email to admin
			ProjectsMailer.project_email(@project).deliver
			
			redirect_to root_url, :notice => "Got it! Your entry is currently waiting approval"
    else
      render :new, :alert => "An error ocurred while creating the Project"
    end
  end

  def edit
    @project = Project.find(params[:id])  
  end

  def update
    # TODO: notify user when they gain ownership of a project?
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

    unless @project.votes.where(:user_id => current_user).any?
      @project.votes.create(:user_id => current_user.id)
      @points = @project.votes.count
      render 'promote.js'
    else
      render :js => 'console.log("ha!")'
    end
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

  def prevent_mass_assign
    # if the user is not an admin, we remove :user_id from params
    # TODO: more modernized approach
    params[:project].delete(:user_id) unless current_user_admin?
  end
end
