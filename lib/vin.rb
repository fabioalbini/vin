require 'forwardable'

require_relative './validator'
require_relative './suggester'

class Vin
  extend Forwardable
  def_delegators :validation_response, :valid?, :errors

  def initialize(vin_code, validator: Validator, suggester: Suggester)
    @vin_code = vin_code.to_s.upcase.strip
    @validator = validator
    @suggester = suggester
  end

  def to_s
    vin_code
  end

  def suggestions
    return [] if valid?

    @suggestions ||= suggester.new(vin_code).call
  end

  private

  attr_reader :vin_code, :validator, :suggester

  def validation_response
    @validation_response ||= validator.new(vin_code).call
  end
end
