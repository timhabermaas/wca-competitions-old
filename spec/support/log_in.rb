module Capybara
  module SessionHelper
    def log_in # TODO :as => :admin
      user = create :user, :password => "secret", :password_confirmation => "secret"
      visit log_in_path
      fill_in "email", :with => user.email
      fill_in "password", :with => "secret"
      click_on "Log in"
    end
  end
end