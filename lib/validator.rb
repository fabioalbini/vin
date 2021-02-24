require_relative './check_digit_calulator'

class Validator
  Response = Struct.new(
    :valid?,
    :errors,
    keyword_init: true
  )

  Error = Struct.new(
    :message,
    :position,
    :suggestions,
    keyword_init: true
  )

  VIN_LENGTH = 17
  CHECK_DIGIT_POSITION = 8

  def initialize(vin_code, check_digit_calculator: CheckDigitCalculator)
    @vin_code = vin_code.to_s
    @check_digit_calculator = check_digit_calculator
    @errors = []
  end

  def call
    validate_length
    validate_allowed_characters
    validate_check_digit

    Response.new(valid?: errors.empty?, errors: errors)
  end

  private

  attr_reader :vin_code, :errors, :check_digit_calculator

  def validate_length
    if vin_code.size != VIN_LENGTH
      add_error(
        Error.new(message: "should have #{VIN_LENGTH} characters")
      )
    end
  end

  def validate_allowed_characters
    given_characters.each_with_index do |char, index|
      next if allowed_characters.include?(char)

      add_error(
        Error.new(
          message: "has an invalid character of '#{char}'",
          position: index,
          suggestions: allowed_characters
        )
      )
    end
  end

  def validate_check_digit
    return if errors.any?
    return if vin_code[8].to_c == calculated_check_digit

    add_error(
      Error.new(
        message: 'invalid check digit',
        position: CHECK_DIGIT_POSITION,
        suggestions: calculated_check_digit
      )
    )
  rescue CheckDigitCalculator::InvalidCharacter
    Error.new(message: 'invalid check digit', position: CHECK_DIGIT_POSITION)
  end

  def add_error(*errors)
    @errors += errors
  end

  def calculated_check_digit
    @calculated_check_digit ||= check_digit_calculator.new(vin_code).call
  end

  def given_characters
    @given_characters ||= vin_code.split('')
  end

  def allowed_characters
    %w(0 1 2 3 4 5 6 7 8 9 A B C D E F G H J K L M N P R S T U V W X Y Z)
  end
end
