# frozen_string_literal: true

# discount to be calculated by modifying individual cart items' prices
class ProductValueDiscount < BaseDiscount
  CALCULATION_LIFECYCLE_MOMENT = :item_calculation

  def apply!(cart_items)
    cart_items.each do |cart_item|
      next unless cart_item_triggers_discount?(cart_item)

      apply_to_cart_item(cart_item)
    end
  end

  def apply_to_cart_item(cart_item)
    return unless discount_model == 'change_price'

    cart_item.product.discounted_price = discount_value
  end

  def cart_item_triggers_discount?(cart_item)
    # other types of triggers could also be handled
    return unless trigger.type == 'product_present_in_basket'

    cart_item.product.code == trigger.product_code && \
      cart_item.qty >= trigger.min_product_quantity
  end
end
