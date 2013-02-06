class ProjectsMailer < ActionMailer::Base
	default from: "tiramisuGitHub@gmail.com"

	helper :application
	def project_email(project, url)
		admins = User.admins.map(&:email)
		@url = url
		@project = project
		@user = project.user
		mail(:to => admins, :subject => "New Project! (#{@project.name})")
	end
end
