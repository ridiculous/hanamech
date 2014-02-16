class CreateWorkorderJobs < ActiveRecord::Migration
  def change
    create_table :workorder_jobs do |t|
      t.integer :workorder_id, null: false
      t.integer :job_id, null: false
      t.string  :total
      t.timestamps
    end
  end
end
