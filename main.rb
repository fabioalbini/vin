require_relative './lib/vin'

given_vin_code = ARGV[0]
vin = Vin.new(given_vin_code)

puts "Provided VIN: #{vin}"
puts "Check Digit: #{vin.valid? ? 'VALID' : 'INVALID'}"
puts 'This looks like a VALID vin!' if vin.valid?

vin.errors.each do |error|
  puts <<~STR
    -- Error --
    Message: #{error.message}
    Position: #{error.position}
  STR
end
