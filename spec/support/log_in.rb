module Capybara
  module SessionHelper
    def log_in(options = { :as => "organizer" })
      user = create :user, :password => "secret", :password_confirmation => "secret", :role => options[:as]
      visit login_path
      fill_in "email", :with => user.email
      fill_in "password", :with => "secret"
      click_on "Log in"
      user
    end
  end
end