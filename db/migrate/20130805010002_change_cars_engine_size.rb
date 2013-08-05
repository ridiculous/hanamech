class ChangeCarsEngineSize < ActiveRecord::Migration
  def change
    change_column :cars, :engine_size, :string, length: 55
  end
end
