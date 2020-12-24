class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.integer :account_type_id
      t.integer :entity_id
      t.bigint :amount_in_cents
      t.integer :currency_id

      t.timestamps
    end
  end
end
