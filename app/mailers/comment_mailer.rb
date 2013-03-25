class CommentMailer < ActionMailer::Base
  default from: "tiramisuGitHub@gmail.com"
  helper :application

  def comment_email(comment)
    @comment = comment
    @commenter = @comment.user
    @projlead  = @comment.project.user

    # no need to send the project lead his own comment
    unless @commenter == @projlead
      mail(:to => @projlead.email, :subject => "New comment on (#{@comment.project.name})")
    end
  end
end
