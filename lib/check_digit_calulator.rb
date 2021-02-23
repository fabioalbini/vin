class CheckDigitCalculator
  def initialize(vin_code)
    @vin_code = vin_code
  end

  def call
    map = [0, 1, 2, 3, 4, 5, 6, 7, 9, 10, 'X']
    weights = [8, 7, 6, 5, 4, 3, 2, 10, 0, 9, 8, 7, 6, 5, 4, 3, 2]
    sum = 0

    vin_code.split('').each_with_index do |char, i|
      sum += transliterate(char) * weights[i]
    end

    map[sum % 11]
  end

  private

  attr_reader :vin_code

  def transliterate(char)
    '0123456789.ABCDEFGH..JKLMN.P.R..STUVWXYZ'.split('').index(char) % 10
  end
end
