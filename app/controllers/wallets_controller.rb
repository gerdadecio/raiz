class WalletsController < ApplicationController

  def new_fund
    @wallet_account = Account.wallet.find(params[:id])
  end

  def add_fund
    @raiz_invest_wallet_account = Account.app_wallet.find_by(currency: Money.default_currency.iso_code)
    @wallet_account = Account.wallet.find(params[:id])

    wallet_transfer = Transfers::WalletTransfer.new(
      permitted_params[:amount],
      source_account:      @raiz_invest_wallet_account,
      destination_account: @wallet_account,
      code:                :deposit
    )
    if wallet_transfer.valid? && wallet_transfer.perform
      redirect_to @wallet_account.account_holder
    else
      redirect_to new_fund_wallet_path(@wallet_account), error: wallet_transfer.errors.full_messages.join(', ')
    end
  end

  def new_transfer
    @wallet_account = Account.wallet.find(params[:id])
  end

  def transfer_fund
    @wallet_account = Account.wallet.find(params[:id])
    @to_wallet_account = Account.wallet.find_by(id: permitted_params[:to])

    wallet_transfer = Transfers::WalletTransfer.new(
      permitted_params[:amount],
      source_account:      @wallet_account,
      destination_account: @to_wallet_account,
      code:                :transfer
    )

    if wallet_transfer.valid? && wallet_transfer.perform
      redirect_to @wallet_account.account_holder
    else
      redirect_to new_transfer_wallet_path(@wallet_account), error: wallet_transfer.errors.full_messages.join(', ')
    end

  end

private

  def permitted_params
    params.require(:account).permit(:amount, :to)
  end
end
