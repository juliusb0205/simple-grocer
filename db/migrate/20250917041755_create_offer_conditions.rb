class CreateOfferConditions < ActiveRecord::Migration[8.0]
  def change
    create_table :offer_conditions do |t|
      t.references :offer, null: false, foreign_key: true
      t.string :condition_type
      t.text :condition_value

      t.timestamps
    end
  end
end
