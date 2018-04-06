class CreateContacts < ActiveRecord::Migration[5.0]
  def change
    create_table :contacts do |t|
      t.string :firstname
      t.string :lastname
      t.string :email
      t.string :contact_type
      t.string :other
      t.string :mobile
      t.string :office
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
