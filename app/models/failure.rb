# frozen_string_literal: true

class Failure
  attr_reader :name, :error, :type

  def initialize(name:, error:, type:)
    @name = name
    @error = error
    @type = type
  end

  def to_s
    "#{type}: #{name} - #{error}"
  end
end
