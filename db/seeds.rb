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
      quantity:
    )
  end

  puts "Created basket #{index + 1} with #{products.keys.join(', ')}"
end
