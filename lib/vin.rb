require_relative './check_digit_calulator'

class Vin
  attr_reader :vin

  def initialize(vin, check_digit_calculator: CheckDigitCalculator)
    @vin = vin
    @check_digit_calculator = check_digit_calculator
  end

  def valid?
    calculated_check_digit == given_check_digit
  end

  def to_s
    vin
  end

  private

  attr_reader :check_digit_calculator

  def given_check_digit
    vin[8].to_c
  end

  def calculated_check_digit
    @calculated_check_digit ||= check_digit_calculator.new(vin).call
  end
end
