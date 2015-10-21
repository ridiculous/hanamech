class ChangeQuantityWorkorderParts < ActiveRecord::Migration
  def change
    change_column :workorder_parts, :quantity, :string
  end
end
