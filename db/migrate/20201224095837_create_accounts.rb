class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string :identifier
      t.integer :account_holder_id
      t.string :account_holder_type
      t.string :currency
      t.timestamps
    end
  end
end
