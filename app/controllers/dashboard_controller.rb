class DashboardController < ApplicationController
  def index
    @stocks = Stock.all
    @teams = Team.all
    @users = User.all
  end

end
