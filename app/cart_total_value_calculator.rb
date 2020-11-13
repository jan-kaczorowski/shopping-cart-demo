# frozen_string_literal: true

# calculates total value against cart_items and promo rules
class CartTotalValueCalculator
  LIFECYCLE_MOMENTS = %i[item_calculation basket_calculation].freeze

  include CartItemHelpers

  def initialize(promotional_rules:, cart_items:)
    @promotional_rules = promotional_rules.map do |prule|
      BaseDiscount.from_ostruct(prule)
    end
    @cart_items = cart_items
  end

  def call
    apply_discounts

    calculate_total
  end

  def calculate_total
    calculate_total_from_cart_items(cart_items).round(2)
  end

  private

  attr_reader :promotional_rules, :cart_items

  def apply_discounts
    LIFECYCLE_MOMENTS.each do |moment|
      apply_rules_by_lifecycle_moment(moment, cart_items)
    end
  end

  def apply_rules_by_lifecycle_moment(moment, cart_items)
    applicable_rules = promotional_rules_by_moment(moment)
    applicable_rules.each { |rule| rule.apply!(cart_items) }
  end

  def promotional_rules_by_moment(moment)
    promotional_rules.select do |rule|
      rule.class::CALCULATION_LIFECYCLE_MOMENT == moment
    end
  end
end
