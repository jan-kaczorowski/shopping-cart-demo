# frozen_string_literal: true

# Provides checkout and cart items interaction methods
class Checkout
  attr_reader :cart_items

  def initialize
    app_data = AppData.instance
    @promotional_rules = app_data.promotional_rules
    @products = app_data.products
    @cart_items = []
  end

  def scan(product_code, qty = 1)
    product = fetch_product_by_code(product_code)
    add_to_cart(product, qty)
  end

  def total
    CartTotalValueCalculator.new(
      promotional_rules: promotional_rules,
      cart_items: cart_items
    ).call
  end

  private

  attr_reader :products, :promotional_rules

  def add_to_cart(product, qty)
    cart_item = cart_item_by_product(product)

    if cart_item
      cart_item.qty += qty
    else
      cart_items.push(OpenStruct.new(product: product, qty: qty))
    end
  end

  def fetch_product_by_code(product_code)
    products.find { |prod| prod.code == product_code }
  end

  def cart_item_by_product(product)
    cart_items.find { |cart_item| cart_item.product.code == product.code }
  end
end
