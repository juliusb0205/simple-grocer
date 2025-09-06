class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :product_code, null: false
      t.string :name, null: false
      t.integer :price_cents, null: false, default: 0

      t.timestamps
    end
    add_index :products, :product_code, unique: true
    add_index :products, :name
  end
end
