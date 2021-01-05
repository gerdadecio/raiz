require 'double_entry'

DoubleEntry.configure do |config|
  # Use json(b) column in double_entry_lines table to store metadata instead of separate metadata table
  #config.json_metadata = true

  config.define_accounts do |accounts|
    holder_scope = ->(holder) do
      holder
    end

    Account::SUPPORTED_CURRENCIES.each do |currency|
      accounts.define(identifier: :wallet, scope_identifier: holder_scope, currency: currency, positive_only: true)
      accounts.define(identifier: :app_wallet, scope_identifier: holder_scope, currency: currency)
    end
  end

  config.define_transfers do |transfers|
    transfers.define(from: :app_wallet, to: :wallet,  code: :deposit)
    transfers.define(from: :wallet, to: :wallet, code: :transfer)
  end
end
