FactoryBot.define do
  factory :account do
    currency { 'AUD' }

    trait :user_wallet do
      identifier { 'wallet' }
      account_holder {|ah| ah.association(:user)}
    end

    trait :team_wallet do
      identifier { 'wallet' }
      account_holder {|ah| ah.association(:team)}
    end

    trait :stock_wallet do
      identifier { 'wallet' }
      account_holder {|ah| ah.association(:stock)}
    end

    trait :user_app_wallet do
      identifier { 'app_wallet' }
      account_holder {|ah| ah.association(:user)}
    end

  end
end
