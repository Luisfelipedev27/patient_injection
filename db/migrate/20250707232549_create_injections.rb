class CreateInjections < ActiveRecord::Migration[8.0]
  def change
    create_table :injections do |t|
      t.decimal :dose, precision: 8, scale: 2, null: false
      t.string :lot_number, null: false, limit: 6
      t.string :drug_name, null: false
      t.date :injected_at, null: false
      t.references :patient, null: false, foreign_key: true

      t.timestamps
    end

    add_index :injections, [:patient_id, :injected_at]
  end
end
