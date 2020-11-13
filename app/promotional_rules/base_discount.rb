# frozen_string_literal: true

# represents generic discount
class BaseDiscount
  class NoCartItemsError < StandardError; end

  include CartItemHelpers

  class << self
    class TriggerInvalidError < StandardError; end

    def from_ostruct(ostruct)
      klass = Object.const_get(ostruct.type)

      raise TriggerInvalidError unless trigger_valid?(ostruct.trigger)

      klass.new(
        discount_model: ostruct.discount_model,
        discount_value: ostruct.discount_value,
        trigger: ostruct.trigger
      )
    end

    private

    def trigger_valid?(trigger)
      %w[type value].all? { |key| trigger.respond_to?(key) }
    end
  end

  def initialize(discount_model:, discount_value:, trigger:)
    @discount_model = discount_model
    @discount_value = discount_value
    @trigger = trigger
  end

  attr_reader :discount_model, :discount_value, :trigger, :cart_items

  def apply!(_cart_items)
    raise NotImplementedError
  end

  private

  def default_total
    raise NoCartItemsError unless cart_items

    calculate_total_from_cart_items(cart_items)
  end
end
