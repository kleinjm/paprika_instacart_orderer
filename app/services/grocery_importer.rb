# frozen_string_literal: true

require "json"
require_relative "./models/grocery"

class GroceryImporter
  class << self
    def call
      `node ./paprika_api/fetch-groceries.js`

      raw_file = File.read("./tmp/groceries.json")
      JSON.parse(raw_file).map do |grocery_json|
        Grocery.new(grocery_json)
      end
    rescue Errno::ENOENT => e
      handle_missing_groceries(error: e)
      []
    ensure
      delete_grocery_file
    end

    private

    def delete_grocery_file
      File.delete("./tmp/groceries.json")
    rescue Errno::ENOENT => e
      handle_missing_groceries(error: e)
    end

    def handle_missing_groceries(error:)
      puts "Error fetching grocery list from paprika api. #{error}\n" \
           "Check that paprika-api JS script is creating the JSON file."
    end
  end
end
