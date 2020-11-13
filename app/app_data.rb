# frozen_string_literal: true

require 'json'
require 'singleton'

# Pulls products and promo rules data
class AppData
  include Singleton

  def initialize
    puts '-----[LOADED PRODUCTS]-----'.red
    ap products
    puts '-----[LOADED PROMOTIONAL RULES]-----'.red
    ap promotional_rules
  end

  def products
    @products ||= load_json_file('products.json')
  end

  def promotional_rules
    @promotional_rules ||= load_json_file('promotional_rules.json')
  end

  private

  def load_json_file(filename)
    file_contents = File.read(File.join(__dir__, '..', 'data', filename))
    JSON.parse(file_contents, object_class: OpenStruct)
  end
end
