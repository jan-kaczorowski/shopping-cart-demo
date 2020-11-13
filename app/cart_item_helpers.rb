# frozen_string_literal: true

# common methods for calculating totals
module CartItemHelpers
  def calculate_total_from_cart_items(cart_items)
    cart_items.inject(0) do |dtotal, c_item|
      c_item_price = c_item.product.discounted_price || c_item.product.price
      c_item_value = c_item_price * c_item.qty
      dtotal += c_item_value
      dtotal
    end
  end
end
