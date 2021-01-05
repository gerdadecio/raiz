class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]

  def show
    @wallet = @user.wallet_account
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create(permitted_params[:user])
  end

  def edit

  end

  def update
    @user.update_attributes(permitted_params[:user])
  end

private
  def set_user
    @user = User.find(params[:id])
  end
end
