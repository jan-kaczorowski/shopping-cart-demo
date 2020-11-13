# frozen_string_literal: true

# discount to be calculated after individual items' discounts are calculated
class BasketValueDiscount < BaseDiscount
  CALCULATION_LIFECYCLE_MOMENT = :basket_calculation

  def apply!(cart_items)
    @cart_items = cart_items

    return unless triggers_discount?

    apply_discount
  end

  private

  def apply_discount
    return unless discount_model == 'discount_by_percent'

    cart_items.push(discount_cart_item)
  end

  def triggers_discount?
    # other types of triggers could also be handled
    return unless trigger.type == 'min_basket_value'

    default_total >= trigger.value
  end

  def discount_total_value
    default_total * discount_value * -1 / 100
  end

  def discount_cart_item
    discount = OpenStruct.new(price: discount_total_value,
                              name: self.class.name,
                              code: 'DIS')

    OpenStruct.new(product: discount, qty: 1)
  end
end
