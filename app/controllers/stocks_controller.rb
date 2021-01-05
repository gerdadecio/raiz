class StocksController < ApplicationController
  before_action :set_stock, only: [:show, :edit, :update]

  def show
    @wallet = @stock.wallet_account
  end

  def new
    @stock = Stock.new
  end

  def create
    @stock = Stock.create(permitted_params[:stock])
  end

  def edit

  end

  def update
    @stock.update_attributes(permitted_params[:stock])
  end

private
  def set_stock
    @stock = Stock.find(params[:id])
  end
end
