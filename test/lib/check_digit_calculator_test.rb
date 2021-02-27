require 'minitest/autorun'
require 'ostruct'

require_relative '../../lib/check_digit_calculator'

describe CheckDigitCalculator do
  describe '#call' do
    it 'returns the correct check digit for a given vin code' do
      assert_equal(CheckDigitCalculator.call('JH4KA4650JC000403'), '0')
      assert_equal(CheckDigitCalculator.call('JH4DB1641NS802336'), '1')
      assert_equal(CheckDigitCalculator.call('2NKWL00X16M149809'), '2')
      assert_equal(CheckDigitCalculator.call('1G3NF52E3XC403652'), '3')
      assert_equal(CheckDigitCalculator.call('JN1CV6AP4CM626941'), '4')
      assert_equal(CheckDigitCalculator.call('3LNHL2JC5CR800713'), '5')
      assert_equal(CheckDigitCalculator.call('2NKWL00X16M149831'), '6')
      assert_equal(CheckDigitCalculator.call('2FMDK4KC7BBA48439'), '7')
      assert_equal(CheckDigitCalculator.call('1C3CDZBG6DN504146'), '8')
      assert_equal(CheckDigitCalculator.call('2G1WF52KX59355243'), '9')
      assert_equal(CheckDigitCalculator.call('1GKEL19W1RB546238'), 'X')
    end
  end
end
