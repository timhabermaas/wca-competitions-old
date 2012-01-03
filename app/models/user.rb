class User < ActiveRecord::Base
  ROLES = ["admin", "organizer", "user"]

  attr_accessible :name, :email, :password, :password_confirmation

  has_secure_password

  has_many :competitions
  has_many :news

  validates :name, :email, :role, :presence => true
  validates_presence_of :password, :on => :create
  validates :password, :length => { :minimum => 5 }
  validates :name, :email, :uniqueness => true
  validates :role, :inclusion => { :in => ROLES }

  def admin?
    role == "admin"
  end

  def organizer?
    role == "organizer"
  end
end
