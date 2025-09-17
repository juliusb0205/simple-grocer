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

Product.find_or_create_by!(product_code: 'MK1') do |product|
  product.name = 'Milk'
  product.price_cents = 195
end

Product.find_or_create_by!(product_code: 'JM1') do |product|
  product.name = 'Jam'
  product.price_cents = 280
end

puts "Created #{Product.count} products"

offer_1 = Offer.find_by(name: 'Green Tea BOGO')
unless offer_1
  offer_1 = Offer.new(name: 'Green Tea BOGO', description: 'Buy one green tea, get one free', offer_type: :buy_x_take_y)
  offer_1.offer_conditions.build(condition_type: 'base_quantity', condition_value: '1')
  offer_1.offer_conditions.build(condition_type: 'free_quantity', condition_value: '1')
  offer_1.save!
end

green_tea = Product.find_by!(product_code: 'GR1')
ProductOffer.find_or_create_by!(product: green_tea, offer: offer_1)

offer_2 = Offer.find_by(name: 'Strawberry Bulk Discount')
unless offer_2
  offer_2 = Offer.new(name: 'Strawberry Bulk Discount', description: 'Buy 3 or more strawberries for 4.50€ each', offer_type: :quantity_discount)
  offer_2.offer_conditions.build(condition_type: 'minimum_quantity', condition_value: '3')
  offer_2.save!
end

strawberry = Product.find_by!(product_code: 'SR1')
ProductOffer.find_or_create_by!(product: strawberry, offer: offer_2)

offer_3 = Offer.find_by(name: 'Coffee Bulk Discount')
unless offer_3
  offer_3 = Offer.new(name: 'Coffee Bulk Discount', description: 'Buy 3 or more coffees for 2/3 of original price', offer_type: :quantity_discount)
  offer_3.offer_conditions.build(condition_type: 'minimum_quantity', condition_value: '3')
  offer_3.save!
end

coffee = Product.find_by!(product_code: 'CF1')
ProductOffer.find_or_create_by!(product: coffee, offer: offer_3)

offer_4 = Offer.find_by(name: 'Milk Buy 2 Take 1')
unless offer_4
  offer_4 = Offer.new(name: 'Milk Buy 2 Take 1', description: 'Buy 2 milk, get 1 free', offer_type: :buy_x_take_y)
  offer_4.offer_conditions.build(condition_type: 'base_quantity', condition_value: '2')
  offer_4.offer_conditions.build(condition_type: 'free_quantity', condition_value: '1')
  offer_4.save!
end

milk = Product.find_by!(product_code: 'MK1')
ProductOffer.find_or_create_by!(product: milk, offer: offer_4)

offer_5 = Offer.find_by(name: 'Jam Buy 3 Take 2')
unless offer_5
  offer_5 = Offer.new(name: 'Jam Buy 3 Take 2', description: 'Buy 3 jam, get 2 free', offer_type: :buy_x_take_y)
  offer_5.offer_conditions.build(condition_type: 'base_quantity', condition_value: '3')
  offer_5.offer_conditions.build(condition_type: 'free_quantity', condition_value: '2')
  offer_5.save!
end

jam = Product.find_by!(product_code: 'JM1')
ProductOffer.find_or_create_by!(product: jam, offer: offer_5)

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
  scanner = ProductScanner.new(basket)
  products.each do |product_code, quantity|
    quantity.times do
      scanner.scan(product_code)
    end
  end

  puts "Created basket #{index + 1} with #{products.keys.join(', ')}"
end
