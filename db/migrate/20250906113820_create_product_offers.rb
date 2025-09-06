class CreateProductOffers < ActiveRecord::Migration[8.0]
  def change
    create_table :product_offers do |t|
      t.references :product, null: false, foreign_key: true
      t.references :offer, null: false, foreign_key: true

      t.timestamps
    end

    add_index :product_offers, [ :product_id, :offer_id ], unique: true
  end
end
