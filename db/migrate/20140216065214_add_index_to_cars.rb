class AddIndexToCars < ActiveRecord::Migration
  def change
    add_index :cars, :customer_id
  end
end
