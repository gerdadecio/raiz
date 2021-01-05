class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update]

  def show
    @wallet = @team.wallet_account
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.create(permitted_params[:team])
  end

  def edit

  end

  def update
    @team.update_attributes(permitted_params[:team])
  end

private
  def set_team
    @team = Team.find(params[:id])
  end
end
