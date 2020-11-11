class CreateInsurances < ActiveRecord::Migration[6.0]
  def change
    create_table :insurances do |t|
      t.string :name
      t.string :agency_name
      t.string :insurance_type
      t.float :total_cost
      t.string :period

      t.timestamps
    end
  end
end
