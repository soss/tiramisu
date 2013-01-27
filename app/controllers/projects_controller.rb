class ProjectsController < ApplicationController
  before_filter :require_login, :except => [:index, :show]

  before_filter :must_be_creator, :only => [:edit, :update, :destroy]

  def index
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
    @project.user = current_user
    if @project.save
      redirect_to root_url, :notice => "Created New Project"
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
      redirect_to @project, :notice => "Project Updated"
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

    # refactor
    @vote = Vote.new
    @vote.user = current_user
    @vote.project = @project
    @vote.save

    @points = @project.votes.count + 1

    render 'promote.js'
  end

  private

  def must_be_creator
    @project = Project.find(params[:id]) # notice how we set @project here, and don't need to do it later
    redirect_to @project, :alert => "Access Denied" unless @project.user == current_user
  end
end
