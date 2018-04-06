class CreateClaims < ActiveRecord::Migration[5.0]
  def change
    create_table :claims do |t|
      t.string :claim_type
      t.string :incident_type
      t.string :sub_incident_type
      t.string :status
      t.string :policy_ref
      t.datetime  :claim_reported_date
      t.datetime  :claim_loss_date
      t.string :claim_reference_carrier
      t.string :claim_reference_external
      t.string  :claim_reference_external_note
      # t.references :insured_party, foreign_key: true  #create 'insured_party' table
      # t.references :claimant, foreign_key: true  #create 'claimant' table
      # t.integer :bed_room
      # t.integer :bath_room
      t.string :listing_name
      t.text :summary
      t.string :address
      t.boolean :is_contents
      t.boolean :is_commercial
      t.integer :claim_mgr_min_rating
      t.string  :fee_type
      t.integer :max_fee
      t.integer :fee_win_now_price
      # t.string  :workflow  #should this be a reference to workflow table and take all other :wrkflow fields?
      # t.boolean :wkflow_makesafe
      # t.boolean :wkflow_claim_manager
      # t.boolean :wkflow_site_visit
      # t.boolean :wkflow_report_first
      # t.boolean :wkflow_report_final
      # t.boolean :wkflow_first_and_final
      # t.boolean :wkflow_QA
      t.integer :price
      t.integer :value
      t.boolean :active
      t.references :user, foreign_key: true
      # t.references :carrier, foreign_key: true    # Need to create 'carrier' table
      # t.references :skills, foreign_key: true    # Need to create 'skills' table
      t.timestamps
    end
  end
end


# Claim_Mgr_Skills_Required reference
# carrier reference
# insured_party reference
# claimant reference
# Reserve - change from existing 'Price'
