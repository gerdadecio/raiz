class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update]

  def show
    @wallet = @team.wallet_account
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.create(team_params)
    redirect_to root_path
  end

  def edit

  end

  def update
    @team.update_attributes(team_params)
    redirect_to root_path
  end

private
  def set_team
    @team = Team.find(params[:id])
  end

  def team_params
    params.require(:team).permit(:name, :description)
  end
end
