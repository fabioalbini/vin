require 'minitest/autorun'
require 'ostruct'

require_relative '../../lib/validator'

describe Validator do
  describe '#call' do
    describe 'when a valid vin code is given' do
      it 'returns a valid response' do
        validator_response = Validator.new('2NKWL00X16M149834').call

        assert(validator_response.valid?)
        assert_empty(validator_response.errors)
      end
    end

    describe 'when an invalid vin code is given' do
      it 'returns in invalid response with errors' do
        validator_response = Validator.new('INKWL00X16M14983O').call

        assert(!validator_response.valid?)
        assert(validator_response.errors.any?)
      end

      describe 'when vin code with incorrect length is given' do
        it 'returns an invalid length error' do
          validator_response = Validator.new('22222NKWL00X16149834').call
          error = validator_response.errors.first

          assert(!validator_response.valid?)
          assert_equal(validator_response.errors.size, 1)
          assert_equal(error.message, 'should have 17 characters')
        end
      end

      describe 'when a vin code contains invalid characters' do
        it 'returns an invalid character error' do
          validator_response = Validator.new('QNKWL00X16M149834').call
          error = validator_response.errors.first

          assert(!validator_response.valid?)
          assert_equal(validator_response.errors.size, 1)
          assert_equal(error.message, "has an invalid character of 'Q'")
          assert_equal(error.position, 0)
        end
      end

      describe 'when a vin code fails check digit validation' do
        it 'returns an invalid check digit error' do
          validator_response = Validator.new('2NKWL00216M149834').call
          error = validator_response.errors.first

          assert(!validator_response.valid?)
          assert_equal(validator_response.errors.size, 1)
          assert_equal(error.message, 'invalid check digit')
          assert_equal(error.position, 8)
        end
      end

      describe 'when a vin code contains an invalid serial number' do
        it 'returns an invalid serial number error' do
          validator_response = Validator.new('2NKWL00X16M14983A').call
          error = validator_response.errors.first

          assert(!validator_response.valid?)
          assert_equal(validator_response.errors.size, 1)
          assert_equal(error.message, "has an invalid character of 'A'")
          assert_equal(error.position, 16)
        end
      end
    end

    it 'delegates check digit calculation to the calculator class' do
      calculator = Minitest::Mock.new
      calculator.expect :call, 'X', ['2NKWL00X16M149834']

      Validator.new('2NKWL00X16M149834', check_digit_calculator: calculator).call
    end
  end
end
