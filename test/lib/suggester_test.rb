require 'minitest/autorun'
require 'ostruct'

require_relative '../../lib/suggester'

describe Suggester do
  describe '#call' do
    describe 'when a valid vin code is given' do
      it 'returns an empty array' do
        suggestions = Suggester.call('1NXAE09B1RZ155488')
        assert_empty(suggestions)
      end
    end

    describe 'when an invalid vin code is given' do
      describe 'when vin contains an invalid check digit' do
        it 'returns a suggestion with the correct digit' do
          suggestions = Suggester.call('JNKCV61EX9M303716')
          assert_equal(suggestions, ['JNKCV61E09M303716'])
        end
      end

      describe 'when vin contains an invalid character' do
        it 'returns valid codes with the character replaced' do
          suggestions = Suggester.call('INKCV61EX9M303716')
          expected_suggestions =  [
            '5NKCV61EX9M303716',
            'ENKCV61EX9M303716',
            'NNKCV61EX9M303716',
            'VNKCV61EX9M303716'
          ]

          assert_equal(suggestions, expected_suggestions)
        end
      end

      describe 'when vin contains an invalid serial number' do
        it 'returns valid codes with the character replaced' do
          suggestions = Suggester.call('1NKCV61EX9M30371F')
          expected_suggestions = ['1NKCV61EX9M303710']

          assert_equal(suggestions, expected_suggestions)
        end
      end
    end
  end
end
