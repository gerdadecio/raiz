module Transfers

  # We can add business a logic for the wallet transfer here
  class WalletTransfer

    def initialize(money, from:, to:, code:)
      @money = money
      @from = DoubleEntry.account(from.identifier.to_sym, scope: from.id, currency: 'AUD')
      @to = DoubleEntry.account(to.identifier.to_sym, scope: to.id, currency: 'AUD')
      @code = code
    end

    def perform
      DoubleEntry.transfer(@money, from: @from, to: @to, code: @code)
    end

  end
end
