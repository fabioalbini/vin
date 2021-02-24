require_relative './check_digit_calulator'

class Validator
  VIN_LENGTH = 17

  def initialize(vin_code, check_digit_calculator: CheckDigitCalculator)
    @vin_code = vin_code.to_s
    @check_digit_calculator = check_digit_calculator
  end

  def call
    correct_size? && correct_check_digit?
  rescue CheckDigitCalculator::InvalidCharacter
    false
  end

  private

  attr_reader :vin_code, :check_digit_calculator

  def correct_size?
    vin_code.size == VIN_LENGTH
  end

  def correct_check_digit?
    vin_code[8].to_c == calculated_check_digit
  end

  def calculated_check_digit
    @calculated_check_digit ||= check_digit_calculator.new(vin_code).call
  end
end
