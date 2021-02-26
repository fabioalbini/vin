require_relative './validator'

class Suggester
  MAX_REPLACED_POSITIONS = 3

  def initialize(vin_code, validator: Validator)
    @vin_code = vin_code
    @validator = validator
  end

  def call
    invalid_positions = positions_with_errors(vin_code)
    return [] if invalid_positions.size > MAX_REPLACED_POSITIONS

    suggestions(vin_code, invalid_positions)
  end

  private

  attr_reader :vin_code, :validator

  def suggestions(vin_code, positions)
    @suggestions ||= []

    return @suggestions if positions.empty?

    current_position = positions.first
    variations_in_position(vin_code, current_position).each do |new_code|
      if validator.new(new_code).call.valid?
        @suggestions.push(new_code)
      else
        suggestions(new_code, positions - [current_position])
      end
    end

    @suggestions
  end

  def variations_in_position(vin_code, position)
    current_char = vin_code[position]
    possible_characters = allowed_characters - [current_char]

    possible_characters.map do |allowed_char|
      possible_vin_code = vin_code.dup
      possible_vin_code[position] = allowed_char
      possible_vin_code
    end
  end

  def positions_with_errors(vin_code)
    validation = validator.new(vin_code).call
    validation.errors.map(&:position).compact
  end

  def allowed_characters
    %w(0 1 2 3 4 5 6 7 8 9 A B C D E F G H J K L M N P R S T U V W X Y Z)
  end
end
