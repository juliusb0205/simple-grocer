class AddPriceToBasketItems < ActiveRecord::Migration[8.0]
  def change
    add_monetize :basket_items, :price, currency: { present: false }
  end
end
