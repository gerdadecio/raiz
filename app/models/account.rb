class Account < ApplicationRecord

  TYPES = {
    wallet:       'wallet',
    app_wallet:   'app_wallet',
    bank_account: 'bank_account'
  }.freeze

  SUPPORTED_CURRENCIES = ['AUD'].freeze

  #belongs_to :entity
  belongs_to :account_holder, polymorphic: true

  validates :currency, :identifier, :account_holder_type, :account_holder_id, presence: true

  scope :wallet, -> { where(identifier: TYPES[:wallet]) }
  scope :app_wallet, -> { where(identifier: TYPES[:app_wallet]) }

  def balance
    # Returns a Money object
    ledger_account.balance
  end

  def ledger_account
    DoubleEntry.account(self.identifier.to_sym, scope: self.id)
  end

  def transaction_history
    DoubleEntry::Line.where(account: self.identifier, scope: self.id)
  end
end
