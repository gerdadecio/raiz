class WalletsController < ApplicationController

  def new_fund
    @wallet_account = Account.wallet.find(params[:id])
  end

  def add_fund
    @raiz_invest_wallet_account = Account.app_wallet.find_by(currency: Money.default_currency.iso_code)
    @wallet_account = Account.wallet.find(params[:id])

    Transfers::WalletTransfer.new(
      Money.from_amount(permitted_params[:amount].to_f),
      from: @raiz_invest_wallet_account,
      to:   @wallet_account,
      code: :deposit
    ).perform

    redirect_to @wallet_account.account_holder
  end

  def new_transfer
    @wallet_account = Account.wallet.find(params[:id])
  end

  def transfer_fund
    @wallet_account = Account.wallet.find(params[:id])
    @to_wallet_account = Account.wallet.find(permitted_params[:to])

    Transfers::WalletTransfer.new(
      Money.from_amount(permitted_params[:amount].to_f),
      from: @wallet_account,
      to:   @to_wallet_account,
      code: :transfer
    ).perform

    redirect_to @wallet_account.account_holder
  end

private

  def permitted_params
    params.require(:account).permit(:amount, :to)
  end
end
