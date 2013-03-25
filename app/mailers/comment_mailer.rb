class CommentMailer < ActionMailer::Base
	default from: "tiramisuGitHub@gmail.com"

	helper :application
	def comment_email(comment)
		@comment = comment
		user = comment.project.user
		#email = comment.project.user.(:email) #project lead email
		@commenter = comment.user
		mail(:to => user.email, :subject => "New comment on (#{@comment.project.name})")
	end
end
