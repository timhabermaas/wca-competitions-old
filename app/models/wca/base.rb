class WCA::Base < ActiveResource::Base
  self.site = Rails.application.config.wca_api_url

  class << self
    def find_with_cache(*arguments)
      key = cache_key(arguments)
      result = Rails.cache.read(key)

      unless result
        result = find_without_cache(*arguments) || "nil"
        Rails.cache.write(key, result, :expires_in => 6.days)
      end

      result == "nil" ? nil : result.try(:dup)
    end
    alias_method_chain :find, :cache

    def cache_key(*arguments)
      arguments
    end
  end
end
