class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.references :user, foreign_key: true
      t.references :claim, foreign_key: true
      t.string :task_type
      t.string :deliverable_type
      t.string :task_name
      t.text :task_description
      t.string :task_status
      t.string :RAG_status
      t.datetime :task_due
      t.datetime :task_completed
      t.integer :minutes_logged
      t.string :created_by
      t.timestamps
    end
  end
end
