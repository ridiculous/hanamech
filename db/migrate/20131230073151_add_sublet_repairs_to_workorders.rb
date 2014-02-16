class AddSubletRepairsToWorkorders < ActiveRecord::Migration
  def change
    add_column :workorders, :sublet_repairs, :string
  end
end
