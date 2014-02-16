class AddYearMakeModelToCars < ActiveRecord::Migration
  def change
    add_column :cars, :year_make_model, :string
  end
end
