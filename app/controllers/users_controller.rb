class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]

  def show
    @wallet = @user.wallet_account
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.valid?
      @user.save
      redirect_to root_path
    else
      redirect_to new_user_path, error: @user.errors.full_messages.join(', ')
    end
  end

  def edit

  end

  def update
    if @user.update_attributes(user_params)
      redirect_to root_path
    else
      redirect_to edit_user_path(@user), error: @user.errors.full_messages.join(', ')
    end
  end

private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name)
  end
end
