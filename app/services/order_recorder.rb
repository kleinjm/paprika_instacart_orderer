# frozen_string_literal: true

require "active_support/json"

class OrderRecorder
  def self.record_items(items:)
    timestamp = Time.now.strftime("%m%d%Y%H%M")
    store = ENV.fetch("INSTA_STORE")
    file_name = "./recorded_orders/order_#{store}_#{timestamp}.json"

    File.open(file_name, "w") do |file|
      file.puts items.to_json
    end
  end
end
