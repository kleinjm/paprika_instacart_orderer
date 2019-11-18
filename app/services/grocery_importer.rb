# frozen_string_literal: true

require "json"

class GroceryImporter
  GROCERIES_JSON =
    if Rails.env.test?
      Rails.root.join("spec", "support", "sample_data", "groceries.json")
    else
      Rails.root.join("tmp", "groceries.json")
    end

  JS_FETCH_GROCERIES_SCRIPT = Rails.root.join("lib", "fetch-groceries.js")

  class << self
    def call(user:)
      generate_groceries_json(user: user)

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

    def generate_groceries_json(user:)
      if Rails.env.production?
        `node #{JS_FETCH_GROCERIES_SCRIPT} #{user.paprika_credentials}`
      elsif Rails.env.development?
        node_version = File.read(".nvmrc").strip

        # rubocop:disable Metrics/LineLength
        `$HOME/.nvm/versions/node/v#{node_version}/bin/node #{JS_FETCH_GROCERIES_SCRIPT} #{user.paprika_credentials}`
        # rubocop:enable Metrics/LineLength
      end
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
