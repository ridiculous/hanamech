class AddIndexToWorkorders < ActiveRecord::Migration
  def change
    add_index :workorders, :car_id
  end
end
