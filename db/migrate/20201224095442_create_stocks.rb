class CreateStocks < ActiveRecord::Migration[5.2]
  def change
    create_table :stocks do |t|
      t.string :name
      t.string :code
      t.string :company

      t.timestamps
    end
  end
end
