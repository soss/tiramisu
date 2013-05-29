class User < ActiveRecord::Base
  authenticates_with_sorcery!
  attr_accessible :email, :username, :password, :password_confirmation

  validates_confirmation_of :password
  validates_presence_of :email
  validates_uniqueness_of :email, :username

  validates :username, :length => { :in => 3..20 }
  validates :password, :length => { :in => 5..82 }

  validates_format_of :username, :password, :with => /\A.*\Z/
  validates_format_of :email, :with => /\A[\w\+\.]+@[\w\-]+\.\w+\Z/

  has_many :projects, :dependent => :destroy
  has_many :votes, :dependent => :destroy
  has_many :pledges, :dependent => :destroy
  has_many :comments, :dependent => :destroy

  scope :admins, where(:role => 1)
  default_scope order('created_at ASC')

  def update_password(current_password, new_password, new_password_confirmation)
    if User.authenticate(self.username, current_password).present?
      self.password_confirmation = new_password_confirmation #required for test purpose
      self.change_password!(new_password)
    end
  end
  
end
