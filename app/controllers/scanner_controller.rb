class ScannerController < ApplicationController
  def index
    @products = Product.all
    @current_basket = current_basket
  end

  def scan
    scanner = ProductScanner.new(current_basket)
    product_code = params[:product_code]

    scanner.scan(product_code)

    redirect_to scanner_path
  end

  def checkout
    Basket.create!

    redirect_to scanner_path
  end

  private

  def current_basket
    Basket.last || Basket.create!
  end
end
