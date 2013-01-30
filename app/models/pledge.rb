class Pledge < ActiveRecord::Base
  attr_accessible :project_id

  belongs_to :user
  belongs_to :project
end
