require "spec_helper"

describe "Sessions" do
  before :each do
    create :admin, :name => "tim", :email => "foo@bar.com",
                   :password => "secret", :password_confirmation => "secret"
  end

  describe "log in" do
    it "logs in successfully" do
      visit login_path
      fill_in "email", :with => "foo@bar.com"
      fill_in "password", :with => "secret"
      click_on "Log in"
      page.should have_content "Successfully logged in."
      page.should have_content "tim"
    end
  end

  describe "log out" do
    it "logs out successfully" do
      visit login_path
      fill_in "email", :with => "foo@bar.com"
      fill_in "password", :with => "secret"
      click_on "Log in"
      click_on "Logout"
      page.should have_content "Successfully logged out"
      page.should_not have_content "tim"
    end
  end

  describe "unauthorized" do
    it "redirects to log in page if user is not authorized" do
      visit new_admin_competition_path
      page.should have_content "You're not authorized to access this page!"
      page.should have_field "email"
      page.should have_field "password"
    end

    describe "redirect saving" do
      it "redirects back to the site it left" do
        visit admin_competitions_path

        fill_in "email", :with => "foo@bar.com"
        fill_in "password", :with => "secret"
        click_on "Log in"

        current_path.split("/").last.should == "competitions"
      end

      it "redirects to admin root if visting login page directly" do
        visit login_path

        fill_in "email", :with => "foo@bar.com"
        fill_in "password", :with => "secret"
        click_on "Log in"

        current_path.split("/").last.should == "admin"
      end
    end
  end
end
