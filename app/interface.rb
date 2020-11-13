# frozen_string_literal: true

# Provides simplistic shell interface for checkouts
class Interface
  PRODUCT_CODE_REGEX = /\d{3}/.freeze

  def initialize
    @checkout = Checkout.new
  end

  def call
    ask_for_product_codes

    add_products_to_cart

    display_cart_contents

    display_total_value
  end

  private

  attr_reader :checkout, :product_codes

  def ask_for_product_codes
    puts 'Enter product codes delimited by space:'.red

    @product_codes = gets.chomp.split(' ')

    validate_product_codes
  end

  def add_products_to_cart
    product_codes.map { |p_code| checkout.scan(p_code) }
  end

  def validate_product_codes
    return if product_codes.all? do |pcode|
      pcode.match(PRODUCT_CODE_REGEX) && valid_product_codes.include?(pcode)
    end

    raise StandardError, 'product codes invalid'.red
  end

  def valid_product_codes
    @valid_product_codes ||= AppData.instance.products.map(&:code)
  end

  def display_cart_contents
    ap checkout.cart_items
  end

  def display_total_value
    puts 'Total value is: '.red + checkout.total.to_s.blue
  end
end
