class User < ActiveRecord::Base
  authenticates_with_sorcery!
  attr_accessible :email, :username, :password, :password_confirmation

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email, :username
  validates_uniqueness_of :email, :username

  has_many :projects, :foreign_key => 'user_id'
end
