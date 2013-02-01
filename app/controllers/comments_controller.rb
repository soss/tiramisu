class CommentsController < ApplicationController
  before_filter :require_login
  before_filter :must_be_creator, :except => [:create]

  def create
    @comment = Comment.new(params[:comment])
    @comment.project_id = params[:project_id]
    @comment.user = current_user

    if @comment.save
      redirect_to @comment.project, :notice => 'Comment saved!'
    else
      redirect_to @comment.project, :alert => 'Could not save comment'
    end
  end

  def edit
    #@comment = Comment.find(params[:id])
  end

  def update
    #@comment = Comment.find(params[:id])

    if @comment.update_attributes(params[:comment])
      redirect_to @comment.project, :notice => 'Comment updated!'
    else
      redirect_to @comment.project, :alert => 'Could not update comment'
    end
  end

  def destroy
    #@comment = Comment.find(params[:id])

    if @comment.destroy
      redirect_to @comment.project, :notice => 'Comment deleted'
    else
      redirect_to @comment.project, :alert => 'Comment could not be deleted'
    end
  end

  private

  def must_be_creator
    return if current_user_admin?
    @comment = Comment.find(params[:id]) # notice how we set @project here, and don't need to do it later
    redirect_to @comment.project, :alert => "Access Denied" unless @comment.user == current_user
  end

end
