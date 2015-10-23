class AddFormIndexToWorkorderJobs < ActiveRecord::Migration
  def change
    add_column :workorder_jobs, :form_index, :integer, default: 0
  end
end
