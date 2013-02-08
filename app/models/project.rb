class Project < ActiveRecord::Base
  attr_accessible :description, :language, :long_description, :name, :user_id
  # we don't want to allow mass-assignment for accepted, etc.

  has_many :votes, :dependent => :destroy
  has_many :pledges, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  belongs_to :user

  scope :sorted_by_votes, where(:approved => true)
                          .joins(:votes)
                          .group('projects.id')
                          .order('COUNT(*) DESC')

  def promoted_by?(user)
    self.votes.where(:user_id => user).any?
  end

  def pledged_by?(user)
    self.pledges.where(:user_id => user).any?
  end

end
