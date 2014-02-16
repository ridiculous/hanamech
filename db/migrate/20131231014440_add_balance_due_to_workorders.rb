class AddBalanceDueToWorkorders < ActiveRecord::Migration
  def change
    add_column :workorders, :balance_due, :float
  end
end
