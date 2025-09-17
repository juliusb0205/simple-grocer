class RemoveColumnsFromOffers < ActiveRecord::Migration[8.0]
  def change
    remove_column :offers, :rate_type, :integer
    remove_column :offers, :percentage_rate, :decimal
    remove_column :offers, :fixed_price_cents, :integer
    remove_column :offers, :fixed_price_currency, :string
    remove_column :offers, :minimum_quantity, :integer
  end
end
