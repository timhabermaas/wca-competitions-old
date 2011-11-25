require 'spec_helper'

describe User do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :email }
    it { should validate_presence_of :password_digest }

    it "requires password and password_confirmation to be equal on creation" do
      user = User.new :name => "blub", :email => "muh@cow.com", :password => "1234", :password_confirmation => "12345"
      user.should_not be_valid
      user.errors[:password].should_not be_empty
    end

    it "requires password to be at least 5 characters long" do
      user = build :user, :password => "test", :password_confirmation => "test"
      user.should_not be_valid
      user.errors[:password].should_not be_empty
    end

    it "validates uniqueness of name" do
      u1 = create :user
      u2 = build :user, :name => u1.name
      u2.should_not be_valid
      u2.errors[:name].should_not be_empty
    end

    it "validates uniqueness of email" do
      u1 = create :user
      u2 = build :user, :email => u1.email
      u2.should_not be_valid
      u2.errors[:email].should_not be_empty
    end
  end
end
