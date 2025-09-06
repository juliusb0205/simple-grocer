class CreateOffers < ActiveRecord::Migration[8.0]
  def change
    create_table :offers do |t|
      t.string :name, null: false
      t.text :description
      t.integer :discount_type
      t.integer :rate_type
      t.decimal :percentage_rate, precision: 5, scale: 2
      t.monetize :fixed_price
      t.integer :minimum_quantity

      t.timestamps
    end
  end
end
