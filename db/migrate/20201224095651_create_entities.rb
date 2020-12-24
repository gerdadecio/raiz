class CreateEntities < ActiveRecord::Migration[5.2]
  def change
    create_table :entities do |t|
      t.string :entity_holder_type
      t.integer :entity_holder_id

      t.timestamps
    end
  end
end
