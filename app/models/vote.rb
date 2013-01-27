class Vote < ActiveRecord::Base
  attr_accessible :project_id

  belongs_to :project
  belongs_to :user
end
