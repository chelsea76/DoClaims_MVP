class AddInusrerToClaims < ActiveRecord::Migration[5.0]
  def change
    add_column :claims, :insurer, :string
  end
end
