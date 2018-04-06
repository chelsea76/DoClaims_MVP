class AddForClaimToClaimContactMappings < ActiveRecord::Migration[5.0]
  def change
    add_column :claim_contact_mappings, :for_claim, :boolean, default: false
  end
end
