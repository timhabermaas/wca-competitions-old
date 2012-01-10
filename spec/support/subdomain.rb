module Capybara
  module SubdomainHelper
    def visit_with_subdomain(path, subdomain)
      Capybara.app_host = "http://#{subdomain}.example.com"
      visit path
    end
  end
end
