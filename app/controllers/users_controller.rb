class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]

  def show
    @wallet = @user.wallet_account
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    redirect_to root_path
  end

  def edit

  end

  def update
    @user.update_attributes(user_params)
    redirect_to root_path
  end

private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name)
  end
end
