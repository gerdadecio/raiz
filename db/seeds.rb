# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Users
users = [
  {first_name: "Raiz", last_name: "Invest"},
  {first_name: "John", last_name: "Depp"},
  {first_name: "Mary", last_name: "Jane"},
  {first_name: "Anna", last_name: "Bell"},
  {first_name: "Bobby", last_name: "Burns"}
]
users.each do |user|
  u = User.find_or_create_by(user)

  # NOTES: Create an app_wallet that will act as our vault.
  # It is allowed to have a negative value and we will use this to fund
  # the wallets of our customers
  if user[:first_name] == 'Raiz'
    Account.find_or_create_by(
      identifier: Account::TYPES[:app_wallet],
      currency: Money.default_currency.iso_code,
      account_holder_type: u.class.name.to_s,
      account_holder_id: u.id
    )
  end
end

# Team
teams = [
  {name: "Team 1", description: "Team 1 description"},
  {name: "Team 2", description: "Team 2 description"}
]
teams.each do |team|
  Team.find_or_create_by(team)
end

# Stocks
stocks = [
  {name: "Amazon", code: 'AMZN', company: "Amazon.com Inc."},
  {name: "Apple", code: 'AAPL', company: "Apple Inc"},
  {name: "Tesla", code: 'TSLA', company: "Tesla Inc"},
  {name: "Microsoft", code: 'MSFT', company: "Microsoft Corporation"}
]
stocks.each do |stock|
  Stock.find_or_create_by(stock)
end
