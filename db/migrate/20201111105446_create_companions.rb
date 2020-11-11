class CreateCompanions < ActiveRecord::Migration[6.0]
  def change
    create_table :companions do |t|
      t.references :user
      t.integer :contact_id

      t.timestamps
    end
  end
end
