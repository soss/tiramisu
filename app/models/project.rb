class Project < ActiveRecord::Base
  attr_accessible :accepted, :accepted_date, :creator, :description, :language, :long_description, :name

  has_many :votes
  belongs_to :user, :foreign_key => :user_id
end
