module Capybara
  module SessionHelper
    def log_in(options = { :as => "user" })
      user = create :user, :password => "secret", :password_confirmation => "secret", :role => options[:as]
      visit new_user_session_path
      fill_in "Email", :with => user.email
      fill_in "Password", :with => "secret"
      click_on "Login"
      user
    end
  end
end