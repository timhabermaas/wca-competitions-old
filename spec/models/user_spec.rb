require 'spec_helper'

describe User do
  describe "validations" do
    before :each do
      create :user
    end

    it { should validate_presence_of :name }
    it { should validate_presence_of :email }
    it { should validate_presence_of :role }
    it { should validate_uniqueness_of :name }
    it { should validate_uniqueness_of :email }

    it { should allow_value("organizer").for(:role) }
    it { should allow_value("admin").for(:role) }
    it { should allow_value("user").for(:role) }
    it { should_not allow_value("blub").for(:role) }
  end

  it "has 'user' as default for role" do
    User.new.role.should == "user"
  end
end
