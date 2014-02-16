class AddTaxTotalToWorkorders < ActiveRecord::Migration
  def change
    add_column :workorders, :tax_total, :float
  end
end
