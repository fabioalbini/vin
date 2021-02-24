require 'forwardable'

require_relative './validator'

class Vin
  extend Forwardable
  def_delegators :validation_response, :valid?, :errors

  def initialize(vin_code, validator: Validator)
    @vin_code = vin_code.to_s.upcase.strip
    @validator = validator
  end

  def to_s
    vin_code
  end

  private

  attr_reader :vin_code, :validator

  def validation_response
    validator.new(vin_code).call
  end
end
