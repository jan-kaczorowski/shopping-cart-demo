# frozen_string_literal: true

# Tests one test case as defined in the /test/data.yml file
class Tester
  def initialize(test_case_data)
    @product_codes = test_case_data['product_codes']
    @expected_total = test_case_data['expected_total']
    @checkout = Checkout.new
  end

  attr_reader :product_codes, :expected_total, :total, :checkout

  def test_case!
    print_test_conditions

    product_codes.map { |p_code| checkout.scan(p_code) }

    @total = checkout.total
    print_total_value
    print_test_result
  end

  private

  def print_test_conditions
    puts 'Product codes in input: '.red + product_codes.inspect
    puts 'Expected total: '.red + expected_total.to_s
  end

  def print_total_value
    puts 'Total value is: '.red + total.to_s.blue
  end

  def print_test_result
    passed_msg = "[TEST CASE PASSED] \u2714".green
    failed_msg = "[TEST CASE FAILED] \u274c".red

    puts total == expected_total ? passed_msg : failed_msg
  end
end
