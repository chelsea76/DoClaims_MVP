class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :task_types do |t|
      t.string :name
      t.string :description
    end
    create_table :tasks do |t|
      t.references :user, foreign_key: true
      t.references :claim, foreign_key: true
      t.references :task_type, foreign_key: true
      t.string :deliverable_type
      t.string :title
      t.string :milestone
      t.text :description
      t.string :status
      t.string :RAG_status
      t.datetime :task_due
      t.datetime :task_completed
      t.integer :minutes_logged
      t.string :created_by
      t.string :updated_by
      t.timestamps
    end
  end
end
