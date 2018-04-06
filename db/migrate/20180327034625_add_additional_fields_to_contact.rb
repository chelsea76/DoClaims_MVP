class AddAdditionalFieldsToContact < ActiveRecord::Migration[5.0]
  def change
  	add_column :contacts, :con_type, :string
  	add_column :contacts, :number, :string
  	add_column :contacts, :street, :string
  	add_column :contacts, :city, :string
  	add_column :contacts, :state, :string
  	add_column :contacts, :postcode, :string
  	add_column :contacts, :country, :string
  end
end
