class StocksController < ApplicationController
  before_action :set_stock, only: [:show, :edit, :update]

  def show
    @wallet = @stock.wallet_account
  end

  def new
    @stock = Stock.new
  end

  def create
    @stock = Stock.new(stock_params)
    if @stock.valid?
      @stock.save
      redirect_to root_path
    else
      redirect_to new_stock_path, error: @stock.errors.full_messages.join(', ')
    end
  end

  def edit

  end

  def update
    if @stock.update_attributes(stock_params)
      redirect_to root_path
    else
      redirect_to edit_user_path(@stock), error: @stock.errors.full_messages.join(', ')
    end
  end

private
  def set_stock
    @stock = Stock.find(params[:id])
  end

  def stock_params
    params.require(:stock).permit(:name, :code, :company)
  end
end
