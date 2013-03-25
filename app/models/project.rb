class Project < ActiveRecord::Base
  attr_accessible :description, :language, :long_description, :name, :user_id, :chosen
  # we don't want to allow mass-assignment for accepted, etc.

  has_many :votes, :dependent => :destroy
  has_many :pledges, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  belongs_to :user

  validates :name, :length => { :in => 5..30 }
  validates :description, :length => { :in => 5..30 }
  validates :long_description, :length => { :in => 5..3000 }
  validates :language, :length => { :in => 1..20 }

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

  # returns the list of emails of those who have pledged
  #   to work on the project
  # to be placed in a textarea or something
  def mailing_list
    self.pledges.collect(&:user).collect(&:email)
  end

end
