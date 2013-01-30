class Project < ActiveRecord::Base
  attr_accessible :description, :language, :long_description, :name
  # we don't want to allow mass-assignment for accepted, user_id, etc.

  has_many :votes, :dependent => :destroy
  has_many :pledges, :dependent => :destroy
  belongs_to :user

  def promoted_by?(user)
    self.votes.where(:user_id => user).any?
  end

end
