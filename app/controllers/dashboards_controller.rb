class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @claims = current_user.claims
  end
end
