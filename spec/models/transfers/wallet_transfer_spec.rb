require 'spec_helper'

describe Transfers::WalletTransfer do

  describe '.initialize' do
    context 'with invalid argument' do
      it 'raises an argument error' do
        expect { described_class.new }.to raise_error(ArgumentError)
        expect { described_class.new(100) }.to raise_error(ArgumentError)
      end
    end

    context 'with valid arguments' do
      let(:source_account) { FactoryBot.create(:account, :user_wallet) }
      let(:dest_account) { FactoryBot.create(:account, :user_wallet) }

      it 'sets the attributes' do
        wallet_transfer = described_class.new(
          100_00,
          source_account: source_account,
          destination_account: dest_account,
          code: 'transfer'
        )
        expect(wallet_transfer.source_account).to eq source_account
        expect(wallet_transfer.destination_account).to eq dest_account
        expect(wallet_transfer.amount).to eq 100_00
        expect(wallet_transfer.code).to eq 'transfer'
        expect(wallet_transfer.valid?).to eq true
      end
    end

    context 'has validations' do
      let(:source_account) { FactoryBot.create(:account, :user_wallet) }
      let(:dest_account) { FactoryBot.create(:account, :user_wallet) }

      it 'validate attributes' do
        wallet_transfer = described_class.new(
          100_00,
          source_account: nil,
          destination_account: dest_account,
          code: 'transfer'
        )
        expect(wallet_transfer.valid?).to eq false
      end
    end
  end

  describe '#perform' do
    let(:app_wallet_account) { FactoryBot.create(:account, :user_app_wallet) }
    let(:source_account) { FactoryBot.create(:account, :user_wallet) }
    let(:dest_account) { FactoryBot.create(:account, :user_wallet) }

    context 'when transferring from wallet to another wallet' do
      context 'when amount is a negative value' do
        it 'returns an error' do
          wallet_transfer = described_class.new(
            -100_00,
            source_account: source_account,
            destination_account: dest_account,
            code: :transfer
          )
          wallet_transfer.perform
          expect(wallet_transfer.valid?).to eq false
          expect(wallet_transfer.errors.full_messages).to eq ['Amount must be greater than 0']
        end
      end

      context 'when amount is a positive value' do
        before do
          described_class.new(
            100,
            source_account: app_wallet_account,
            destination_account: source_account,
            code: :deposit
          ).perform
        end

        context 'when source wallet has insufficient balance' do
          it 'does not allow the transfer' do
            wallet_transfer = described_class.new(
              500_00,
              source_account: source_account,
              destination_account: dest_account,
              code: :transfer
            )
            wallet_transfer.perform
            expect(wallet_transfer.errors.full_messages).to eq ['Invalid transfer']
          end
        end

        it 'allows the transfer' do
          wallet_transfer = described_class.new(
            100,
            source_account: source_account,
            destination_account: dest_account,
            code: :transfer
          )

          wallet_transfer.perform

          expect(wallet_transfer.valid?).to eq true
          expect(wallet_transfer.errors.full_messages).to eq []
          expect(dest_account.balance.format).to eq "$100.00"
          expect(source_account.balance.format).to eq "$0.00"
        end
      end

      context 'when amount is non-numeric' do
        it 'returns an error' do
          wallet_transfer = described_class.new(
            'abcde',
            source_account: source_account,
            destination_account: dest_account,
            code: :transfer
          )

          wallet_transfer.perform

          expect(wallet_transfer.valid?).to eq false
          expect(wallet_transfer.errors.full_messages).to eq ['Amount is not a number']
        end
      end
    end

    context 'when transferring to an invalid account' do
      it 'returns an error' do
        wallet_transfer = described_class.new(
          100,
          source_account: source_account,
          destination_account: nil,
          code: :transfer
        )

        wallet_transfer.perform

        expect(wallet_transfer.valid?).to eq false
        expect(wallet_transfer.errors.full_messages).to eq ['Destination account is invalid']
      end
    end

    context 'when transferring from app wallet to wallet' do
      it 'allows the transfer' do
        app_wallet_transfer = described_class.new(
          100,
          source_account: app_wallet_account,
          destination_account: dest_account,
          code: :deposit
        )
        app_wallet_transfer.perform

        expect(app_wallet_transfer.valid?).to eq true
        expect(app_wallet_transfer.errors.full_messages).to eq []
      end
    end

    context 'when app wallet has negative balance' do
      it 'allows the transfer' do
        described_class.new(
          100,
          source_account: app_wallet_account,
          destination_account: dest_account,
          code: :deposit
        ).perform

        expect(app_wallet_account.balance.format).to eq '$-100.00'

        described_class.new(
          100,
          source_account: app_wallet_account,
          destination_account: dest_account,
          code: :deposit
        ).perform

        expect(app_wallet_account.balance.format).to eq '$-200.00'
      end
    end

    context 'when there are multiple transfers from one wallet at the sime time' do
      it 'handles the transfer gracefully' do
        begin
          described_class.new(
            100,
            source_account: app_wallet_account,
            destination_account: source_account,
            code: :deposit
          ).perform

          concurrency_level = 4

          transfers = concurrency_level.times.map do
            described_class.new(
              100,
              source_account: source_account,
              destination_account: dest_account,
              code: :transfer
            )
          end

          @failed_transfer = ''
          wait_for_it  = true
          threads = concurrency_level.times.map do |i|
            Thread.new do
              true while wait_for_it
              transfers[i].perform
              if transfers[i].errors.full_messages.present?
                @failed_transfer = transfers[i].errors.full_messages
              end
            end
          end
          wait_for_it = false
          threads.each(&:join)

          expect(source_account.balance.format).to eq "$0.00"
          expect(@failed_transfer).to eq ['Invalid transfer']
        ensure
          ActiveRecord::Base.connection_pool.disconnect!
        end
      end
    end

  end
end
