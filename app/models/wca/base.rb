class WCA::Base < ActiveResource::Base
  self.site = Rails.application.config.wca_api_url
end
