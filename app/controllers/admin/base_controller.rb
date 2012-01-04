module Admin
  class BaseController < ApplicationController
    def current_ability
      @ability ||= AdminAbility.new(current_user)
    end
  end
end
