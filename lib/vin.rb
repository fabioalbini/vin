require_relative './validator'

class Vin
  def initialize(vin_code, validator: Validator)
    @vin_code = vin_code.to_s.upcase.strip
    @validator = validator
  end

  def valid?
    validator.new(vin_code).call
  end

  def to_s
    vin_code
  end

  private

  attr_reader :vin_code, :validator
end
