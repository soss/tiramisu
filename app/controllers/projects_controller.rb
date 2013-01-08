class ProjectsController < ApplicationController
  before_filter :require_login, :except => [:index, :show]

  def index
    @projects = Project.all
  end

  def home
    @projects = Project.all    
  end

  def show
    @project = Project.find(params[:id])
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(params[:project])
    @project.update_attribute(:user_id, current_user.id)
    @project.save
    redirect_to root_url 
  end

  def edit
    @project = Project.find(params[:id])
    if current_user.id != @project.user_id
      redirect_to redirect_to @project, :notice => "You do not have permission to Edit this project"
    end
    
  end

  def update
    @project = Project.find(params[:id])
    if current_user.id != @project.user_id
      redirect_to redirect_to @project, :notice => "You do not have permission to Edit this project"
    end
    @project.update_attributes(params[:project])
    redirect_to @project
  end

  def destroy
    @project = Project.find(params[:id])
    if current_user.id != @project.user_id
      redirect_to redirect_to @project, :notice => "You do not have permission to Delete this project"
    end
    @project.destroy

    redirect_to root_url, :notice => "Project destroyed"
  end
end
