# frozen_string_literal: true

require "json"

class GroceryImporter
  GROCERIES_JSON = Rails.root.join("tmp", "groceries.json")

  JS_FETCH_GROCERIES_SCRIPT = Rails.root.join("lib", "fetch-groceries.js")

  class << self
    def call(user:, json_file: GROCERIES_JSON)
      generate_groceries_json(user: user)

      raw_file = File.read(json_file)
      JSON.parse(raw_file).map do |grocery_json|
        Grocery.new(grocery_json)
      end
    rescue Errno::ENOENT => e
      handle_missing_groceries_file(error: e)
      []
    ensure
      delete_grocery_file(json_file)
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

    def delete_grocery_file(json_file)
      File.delete(json_file)
    rescue Errno::ENOENT => e
      handle_missing_groceries_file(error: e)
    end

    def handle_missing_groceries_file(error:)
      Rails.logger.error(
        "Error fetching grocery list from paprika api. #{error}\n" \
        "Check that paprika-api JS script is creating the JSON file."
      )
    end
  end
end
