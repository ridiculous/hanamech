class CreateWorkorders < ActiveRecord::Migration
  def self.up
    create_table :workorders do |t|
      t.string :details
      t.string :materials
      t.date :date
      t.string :odometer
      t.string :parts
      t.string :labor
      t.string :tax
      t.string :total
      t.integer :car_id

      t.timestamps
    end
  end

  def self.down
    drop_table :workorders
  end
end
