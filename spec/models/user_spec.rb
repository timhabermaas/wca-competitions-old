require 'spec_helper'

describe User do
  describe "validations" do
    before :each do
      create :user
    end

    it { should validate_presence_of :name }
    it { should validate_presence_of :email }
    it { should validate_presence_of :password_digest }
    it { should validate_presence_of :role }
    it { should validate_uniqueness_of :name }
    it { should validate_uniqueness_of :email }

    it { should allow_value("organizer").for(:role) }
    it { should allow_value("admin").for(:role) }
    it { should allow_value("user").for(:role) }
    it { should_not allow_value("blub").for(:role) }

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
  end

  it "has 'user' as default for role" do
    User.new.role.should == "user"
  end
end
