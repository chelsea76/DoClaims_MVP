class CreateAttachments < ActiveRecord::Migration[5.0]
  def change
    create_table :attachments do |t|
      t.string :file_type
      t.references :claim, foreign_key: true
      t.references :damage, foreign_key: true
      t.attachment :file

      t.timestamps
    end
  end
end
