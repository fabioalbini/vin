require_relative './lib/vin'

given_vin_code = ARGV[0]
vin = Vin.new(given_vin_code)

puts "You gave me: #{vin}"
vin.errors.each do |error|
  puts <<~STR
    -- Error --
    Message: #{error.message}
    Position: #{error.position}
  STR
end
