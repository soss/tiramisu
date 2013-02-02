class User < ActiveRecord::Base
  authenticates_with_sorcery!
  attr_accessible :email, :username, :password, :password_confirmation

  validates_confirmation_of :password
  validates_presence_of :email
  validates_uniqueness_of :email, :username

	validates :username, :length => { :in => 3..20 }
	validates :password, :length => { :in => 5..32 }

	validates_format_of :username, :password, :with => /\A\w*\Z/
	validates_format_of :email, :with => /\A\w+\.\w+\Z/

  has_many :projects, :dependent => :destroy
  has_many :votes, :dependent => :destroy
  has_many :pledges, :dependent => :destroy
end
