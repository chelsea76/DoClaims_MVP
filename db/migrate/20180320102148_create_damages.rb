class CreateDamages < ActiveRecord::Migration[5.0]
  def change
    create_table :damages do |t|
      t.string :description
      t.text :summary
      t.string :damage_type
      t.string :sub_type
      t.float :product_cost
      t.float :labour_cost
      t.attachment :photo
      t.references :claim, foreign_key: true

      t.timestamps
    end
  end
end
