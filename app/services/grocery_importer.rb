# frozen_string_literal: true

require "json"

class GroceryImporter
  GROCERIES_JSON =
    if Rails.env.test?
      Rails.root.join("spec", "support", "sample_data", "groceries.json")
    else
      Rails.root.join("tmp", "groceries.json")
    end

  class << self
    def call
      `node #{js_import_file}`

      raw_file = File.read(GROCERIES_JSON)
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

    def js_import_file
      Rails.root.join("lib", "fetch-groceries.js")
    end

    def delete_grocery_file
      return if Rails.env.test?

      File.delete(GROCERIES_JSON)
    rescue Errno::ENOENT => e
      handle_missing_groceries(error: e)
    end

    def handle_missing_groceries(error:)
      puts "Error fetching grocery list from paprika api. #{error}\n" \
           "Check that paprika-api JS script is creating the JSON file."
    end
  end
end
