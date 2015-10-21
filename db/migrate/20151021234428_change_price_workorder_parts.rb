class ChangePriceWorkorderParts < ActiveRecord::Migration
  def change
    change_column :workorder_parts, :price, :string
  end
end
