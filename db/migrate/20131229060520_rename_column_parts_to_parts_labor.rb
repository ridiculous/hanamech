class RenameColumnPartsToPartsLabor < ActiveRecord::Migration
  def change
    rename_column :workorders, :parts, :parts_total
  end
end
