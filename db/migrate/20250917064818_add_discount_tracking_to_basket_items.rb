class AddDiscountTrackingToBasketItems < ActiveRecord::Migration[8.0]
  def change
    add_column :basket_items, :discount_amount_cents, :integer, default: 0
    add_reference :basket_items, :applied_offer, null: true, foreign_key: { to_table: :offers }
  end
end
