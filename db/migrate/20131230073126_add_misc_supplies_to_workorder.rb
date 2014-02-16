class AddMiscSuppliesToWorkorder < ActiveRecord::Migration
  def change
    add_column :workorders, :misc_supplies, :string
  end
end
