class AddPriceToWorkorderParts < ActiveRecord::Migration
  def change
    add_column :workorder_parts, :price, :float
  end
end
