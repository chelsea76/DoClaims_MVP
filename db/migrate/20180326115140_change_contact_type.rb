class ChangeContactType < ActiveRecord::Migration[5.0]
  def change
  	rename_column :contacts, :contact_type, :type
  end
end
