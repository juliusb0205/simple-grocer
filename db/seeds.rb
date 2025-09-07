# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Product.find_or_create_by!(product_code: 'GR1') do |product|
  product.name = 'Green Tea'
  product.price_cents = 311
end

Product.find_or_create_by!(product_code: 'SR1') do |product|
  product.name = 'Strawberries'
  product.price_cents = 500
end

Product.find_or_create_by!(product_code: 'CF1') do |product|
  product.name = 'Coffee'
  product.price_cents = 1123
end

puts "Created #{Product.count} products"

offer_1 = Offer.find_or_create_by!(name: 'Green Tea BOGO') do |offer|
  offer.description = 'Buy one green tea, get one free'
  offer.discount_type = :buy_one_take_one
  offer.minimum_quantity = 2
end

green_tea = Product.find_by!(product_code: 'GR1')
ProductOffer.find_or_create_by!(product: green_tea, offer: offer_1)

offer_2 = Offer.find_or_create_by!(name: 'Strawberry Bulk Discount') do |offer|
  offer.description = 'Buy 3 or more strawberries for 4.50€ each'
  offer.discount_type = :quantity_discount
  offer.rate_type = :fixed_price
  offer.fixed_price_cents = 450
  offer.minimum_quantity = 3
end

strawberry = Product.find_by!(product_code: 'SR1')
ProductOffer.find_or_create_by!(product: strawberry, offer: offer_2)

offer_3 = Offer.find_or_create_by!(name: 'Coffee Bulk Discount') do |offer|
  offer.description = 'Buy 3 or more coffees for 2/3 of original price'
  offer.discount_type = :quantity_discount
  offer.rate_type = :percentage_rate
  offer.percentage_rate = 66.66
  offer.minimum_quantity = 3
end

coffee = Product.find_by!(product_code: 'CF1')
ProductOffer.find_or_create_by!(product: coffee, offer: offer_3)

puts "Created #{Offer.count} offers"

baskets_data = [
  {
    "GR1" => 3,
    "SR1" => 1,
    "CF1" => 1
  },
  {
    "GR1" => 2
  },
  {
    "SR1" => 3,
    "GR1" => 1
  },
  {
    "GR1" => 1,
    "CF1" => 3,
    "SR1" => 1
  }
]

baskets_data.each_with_index do |products, index|
  basket = Basket.create!

  products.each do |product_code, quantity|
    product = Product.find_by!(product_code:)
    BasketItem.create!(
      basket:,
      product:,
      quantity:,
      price_cents: product.price_cents * quantity
    )
  end

  puts "Created basket #{index + 1} with #{products.keys.join(', ')}"
end
