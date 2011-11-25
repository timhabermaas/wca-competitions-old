require "spec_helper"

describe "Sessions" do
  before :each do
    create :user, :name => "tim", :email => "foo@bar.com",
                  :password => "secret", :password_confirmation => "secret"
  end

  describe "log in" do
    it "logs in successfully" do
      visit log_in_path
      fill_in "email", :with => "foo@bar.com"
      fill_in "password", :with => "secret"
      click_on "Log in"
      page.should have_content("Logged in as tim")
    end
  end

  describe "log out" do
    it "logs out successfully" do
      visit log_in_path
      fill_in "email", :with => "foo@bar.com"
      fill_in "password", :with => "secret"
      click_on "Log in"
      click_on "Log out"
      page.should have_content("logged out")
      page.should_not have_content("Logged in as tim")
    end
  end
end
