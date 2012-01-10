class CompetitionsController < ApplicationController
  load_and_authorize_resource

  before_filter :current_competition, :only => :show

  def index
  end

  def show
  end
end
