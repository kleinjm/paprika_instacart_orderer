# frozen_string_literal: true

require_relative "./lib/grocery_orderer"

# Make sure to set PAPRIKA_EMAIL and PAPRIKA_PASSWORD as well
# Run with DEBUG=true for some more stats
GroceryOrderer.new(
  insta_email: ENV.fetch("INSTA_EMAIL"),
  insta_password: ENV.fetch("INSTA_PASSWORD")
).call
