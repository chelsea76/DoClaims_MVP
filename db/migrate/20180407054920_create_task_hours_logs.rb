class CreateTaskHoursLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :task_hours_logs do |t|
      t.float :minutes_logged
      t.references :task, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
