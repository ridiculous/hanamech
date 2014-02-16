class AddAddressToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :street, :string
    add_column :customers, :city_state, :string
  end
end
