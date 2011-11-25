class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation

  has_secure_password

  validates :name, :email, :presence => true
  validates_presence_of :password, :on => :create
  validates :password, :length => { :minimum => 5 }
end
