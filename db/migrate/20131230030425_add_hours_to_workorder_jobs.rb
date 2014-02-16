class AddHoursToWorkorderJobs < ActiveRecord::Migration
  def change
    add_column :workorder_jobs, :hours, :string
  end
end
