class ChangeCarEngineSizeType < ActiveRecord::Migration
  def change
    change_column :cars, :engine_size, :decimal, :precision => 15, :scale => 4
  end
end
