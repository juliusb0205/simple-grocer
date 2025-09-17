class RenameDiscountTypeToOfferType < ActiveRecord::Migration[8.0]
  def change
    rename_column :offers, :discount_type, :offer_type
  end
end
