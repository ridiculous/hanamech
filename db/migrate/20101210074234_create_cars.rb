class CreateCars < ActiveRecord::Migration
  def self.up
    create_table :cars do |t|
      t.string :car_make
      t.string :car_model
      t.integer :year
      t.float :engine_size
      t.string :vin_number
      t.integer :customer_id

      t.timestamps
    end
  end

  def self.down
    drop_table :cars
  end
end
