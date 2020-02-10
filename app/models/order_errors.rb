# frozen_string_literal: true

# Example
#
# Error message one
# Grocery name: tea
# Amount: 1 cup
#
# Error message two
#
# Error message three
# Error code: 127
class OrderErrors
  def initialize(order)
    @order = order
  end

  def add_error(error_message, metadata = {})
    error_messages << { MESSAGE_KEY => error_message, **metadata }
  end

  def list_errors
    error_messages.map(&method(:list_error)).join("\n\n")
  end

  private

  MESSAGE_KEY = :message
  private_constant :MESSAGE_KEY

  attr_reader :order

  delegate :error_messages, to: :order

  def list_error(message_hash)
    error = message_hash[MESSAGE_KEY]
    metadata = message_hash.without(MESSAGE_KEY)
    return error if metadata.blank?

    format_metadata(error: error, metadata: metadata)
  end

  def format_metadata(error:, metadata:)
    formatted_metadata = metadata.map(&method(:format_key_value))

    "#{error}\n#{formatted_metadata.join("\n")}"
  end

  def format_key_value(key, value)
    "#{key.to_s.humanize}: #{value}"
  end
end
