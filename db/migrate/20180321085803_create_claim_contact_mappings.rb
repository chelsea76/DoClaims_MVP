class CreateClaimContactMappings < ActiveRecord::Migration[5.0]
  def change
    create_table :claim_contact_mappings do |t|
      t.references :claim, foreign_key: true
      t.references :contact, foreign_key: true

      t.timestamps
    end
  end
end
