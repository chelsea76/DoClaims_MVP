class CreateClaimAdditionalDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :claim_additional_details do |t|
      t.integer :insured_id
      t.integer :claimant_id
      t.boolean :is_cat, default: false
      t.string :cat_id
      t.float :excess_amount
      t.references :claim, foreign_key: true

      t.timestamps
    end
    add_column :contacts, :preferred_method, :string, default: 'email'
  end
end
