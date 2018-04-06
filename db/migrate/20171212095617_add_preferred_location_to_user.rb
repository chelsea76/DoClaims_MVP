class AddPreferredLocationToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :preferred_location, :string
  end
end
