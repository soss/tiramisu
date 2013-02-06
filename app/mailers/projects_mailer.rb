class ProjectsMailer < ActionMailer::Base
	default from: "tiramisuGitHub@gmail.com"

	helper :application
	def project_email(project)
		admins = User.admins.map(&:email)
		@project = project
		@user = project.user
		mail(:to => admins, :subject => "New Project! (#{@project.name})")
	end
end
