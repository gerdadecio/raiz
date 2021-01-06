class StocksController < ApplicationController
  before_action :set_stock, only: [:show, :edit, :update]

  def show
    @wallet = @stock.wallet_account
  end

  def new
    @stock = Stock.new
  end

  def create
    @stock = Stock.create(stock_params)
    redirect_to root_path
  end

  def edit

  end

  def update
    @stock.update_attributes(stock_params)
    redirect_to root_path
  end

private
  def set_stock
    @stock = Stock.find(params[:id])
  end

  def stock_params
    params.require(:stock).permit(:name, :code, :company)
  end
end
