class AddLaborTotalToWorkorders < ActiveRecord::Migration
  def change
    add_column :workorders, :labor_total, :float
  end
end
