class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update]

  def show
    @wallet = @team.wallet_account
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    if @team.valid?
      @team.save
      redirect_to root_path
    else
      redirect_to new_team_path, error: @team.errors.full_messages.join(', ')
    end
  end

  def edit

  end

  def update
    if @team.update_attributes(team_params)
      redirect_to root_path
    else
      redirect_to edit_user_path(@team), error: @team.errors.full_messages.join(', ')
    end
  end

private
  def set_team
    @team = Team.find(params[:id])
  end

  def team_params
    params.require(:team).permit(:name, :description)
  end
end
