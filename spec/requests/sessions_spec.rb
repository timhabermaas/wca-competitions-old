require "spec_helper"

describe "Sessions" do
  before :each do
    create :user, :name => "tim", :email => "foo@bar.com",
                  :password => "secret", :password_confirmation => "secret"
  end

  describe "log in" do
    it "logs in successfully" do
      visit login_path
      fill_in "email", :with => "foo@bar.com"
      fill_in "password", :with => "secret"
      click_on "Log in"
      page.should have_content("Logged in as tim")
    end
  end

  describe "log out" do
    it "logs out successfully" do
      visit login_path
      fill_in "email", :with => "foo@bar.com"
      fill_in "password", :with => "secret"
      click_on "Log in"
      click_on "Log out"
      page.should have_content("logged out")
      page.should_not have_content("Logged in as tim")
    end
  end

  describe "unauthorized" do
    it "redirects to log in page if user is not authorized" do
      visit new_competition_path
      page.should have_content("You're not authorized to access this page!")
      page.should have_field("email")
      page.should have_field("password")
    end
  end
end
