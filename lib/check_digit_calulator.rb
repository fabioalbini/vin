class CheckDigitCalculator
  class InvalidCharacter < StandardError; end

  def initialize(vin_code)
    @vin_code = vin_code
  end

  def call
    weights = [8, 7, 6, 5, 4, 3, 2, 10, 0, 9, 8, 7, 6, 5, 4, 3, 2]
    sum = 0
    vin_code.chars.each_with_index do |char, i|
      sum += transliterate(char) * weights[i]
    end

    check_digit = sum % 11

    if check_digit == 10
      'X'
    else
      check_digit.to_s
    end
  end

  private

  attr_reader :vin_code

  def numerical_counterpart(char)
    '0123456789.ABCDEFGH..JKLMN.P.R..STUVWXYZ'.split('').index(char)
  end

  def transliterate(char)
    number = numerical_counterpart(char)
    raise InvalidCharacter, "Given VIN code has an invalid character: #{char}" unless number

    number % 10
  end
end
