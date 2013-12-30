class AddPaidInAdvanceToWorkorders < ActiveRecord::Migration
  def change
    add_column :workorders, :paid_in_advance, :string
  end
end
