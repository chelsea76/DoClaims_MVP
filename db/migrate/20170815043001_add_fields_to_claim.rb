class AddFieldsToClaim < ActiveRecord::Migration[5.0]
  def change
    add_column :claims, :latitude, :float
    add_column :claims, :longitude, :float
  end
end
