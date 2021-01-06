module Transfers

  class WalletTransferError < StandardError; end

  class WalletTransfer
    include ActiveModel::Validations

    validates :destination_account, presence: { message: 'is invalid' }
    validates :source_account, presence: { message: 'is invalid' }
    validates :code, :amount, presence: true
    validates :amount, numericality: true

    attr_accessor :destination_account, :source_account, :code, :amount

    def initialize(amount, source_account:, destination_account:, code:)
      @valid = true
      @amount = amount
      @money = Money.from_amount(amount.to_f)
      @source_account = source_account
      @destination_account = destination_account
      @code = code
    end

    def perform
      DoubleEntry.transfer(
        @money,
        from: DoubleEntry.account(@source_account.identifier.to_sym, scope: @source_account.id, currency: 'AUD'),
        to: DoubleEntry.account(@destination_account.identifier.to_sym, scope: @destination_account.id, currency: 'AUD'),
        code: @code
      )
    rescue DoubleEntry::AccountWouldBeSentNegative => e
      self.errors.add(:base, 'Invalid transfer')
      nil
    end

  end
end
