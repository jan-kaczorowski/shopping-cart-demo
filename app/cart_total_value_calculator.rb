# frozen_string_literal: true

# calculates total value against cart_items and promo rules
class CartTotalValueCalculator
  def initialize(promotional_rules:, cart_items:)
    @promotional_rules = promotional_rules
    @cart_items = cart_items
    @total_value = 0
  end

  def call
    apply_product_value_discounts

    apply_basket_value_discounts
    total
  end

  private

  def apply_product_value_discounts
    1
  end

  def apply_basket_value_discounts
    0
  end

  def total
    @total_value
  end
end
