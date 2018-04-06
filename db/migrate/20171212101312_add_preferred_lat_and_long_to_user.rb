class AddPreferredLatAndLongToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :pref_latitude, :float
    add_column :users, :pref_longtitude, :float
  end
end
