class Comment < ActiveRecord::Base
  attr_accessible :content, :project_id

  belongs_to :user
  belongs_to :project
end
