class CreateContracts < ActiveRecord::Migration[6.0]
  def change
    create_table :contracts do |t|
      t.integer :client_id
      t.integer :user_id
      t.integer :insurance_id

      t.timestamps
    end
  end
end
