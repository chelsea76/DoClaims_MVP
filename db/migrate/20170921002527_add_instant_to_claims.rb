class AddInstantToClaims < ActiveRecord::Migration[5.0]
  def change
    add_column :claims, :instant, :integer, default: 1
  end
end
