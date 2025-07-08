class CreatePatients < ActiveRecord::Migration[8.0]
  def change
    create_table :patients do |t|
      t.string :api_key, null: false
      t.integer :treatment_schedule_days, null: false, default: 3

      t.timestamps
    end

    add_index :patients, :api_key, unique: true
  end
end
