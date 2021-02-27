require 'minitest/autorun'
require 'ostruct'

require_relative '../../lib/vin'

describe Vin do
  describe '#valid?' do
    describe 'when valid vin code given' do
      it 'returns true' do
        vin = Vin.new('2NKWL00X16M149834')
        assert(vin.valid?)
      end
    end

    describe 'when invalid vin code given' do
      it 'returns false' do
        vin = Vin.new('JBDCUB16657005393')
        assert(!vin.valid?)
      end
    end

    it 'delegates validation to the validator class' do
      validator = Minitest::Mock.new
      validator.expect :call, OpenStruct.new(valid?: true), ['2NKWL00X16M149834']

      Vin.new('2NKWL00X16M149834', validator: validator).valid?
    end
  end

  describe '#errors' do
    it 'returns the errors given by the validator class' do
      vin_code = '2NKWL00X16M149834'

      validator = Minitest::Mock.new
      expected_errors = [OpenStruct.new(position: 1, message: 'Test')]
      validator.expect :call, OpenStruct.new(valid?: false, errors: expected_errors), [vin_code]

      assert_equal(
        Vin.new(vin_code, validator: validator).errors,
        expected_errors
      )
    end
  end

  describe '#suggestions' do
    it 'returns the suggestions given by the suggester class' do
      vin_code = 'INKWL00X16M149834'

      validator = Minitest::Mock.new
      validator.expect :call, OpenStruct.new(valid?: false), [vin_code]

      expected_suggestions = ['2NKWL00X16M149834']
      suggester = Minitest::Mock.new
      suggester.expect :call, expected_suggestions, [vin_code]

      vin = Vin.new(
        vin_code,
        validator: validator,
        suggester: suggester
      )

      assert_equal(
        vin.suggestions,
        expected_suggestions
      )
    end
  end

  describe '#to_s' do
    it 'returns the vin code' do
      vin_code = '2NKWL00X16M149834'
      vin = Vin.new(vin_code)

      assert_equal(vin.to_s, vin_code)
    end
  end
end
