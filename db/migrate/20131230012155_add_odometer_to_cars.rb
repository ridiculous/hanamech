class AddOdometerToCars < ActiveRecord::Migration
  def change
    add_column :cars, :odometer, :integer
  end
end
