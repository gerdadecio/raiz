# General handling for accounts.
module AccountHandler
  extend ActiveSupport::Concern

  included do
    has_many :accounts, as: :account_holder
    after_create :create_wallet_account
  end

  def wallet_account
    accounts.find_by(identifier: Account::TYPES[:wallet])
  end

  def create_wallet_account
    Account.find_or_create_by(
      identifier:          Account::TYPES[:wallet],
      currency:            Money.default_currency.iso_code,
      account_holder_type: self.class.name,
      account_holder_id:   self.id
    )
  end

end
