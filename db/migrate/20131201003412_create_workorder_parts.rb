class CreateWorkorderParts < ActiveRecord::Migration
  def change
    create_table :workorder_parts do |t|
      t.integer :part_id
      t.integer :workorder_id
      t.float :quantity

      t.timestamps
    end
  end
end
