require_relative './lib/vin'

given_vin_code = ARGV[0]
vin = Vin.new(given_vin_code)

puts "Provided VIN: #{vin}"
puts "Check Digit: #{vin.valid? ? 'VALID' : 'INVALID'}"

if vin.valid?
  puts 'This looks like a VALID vin!'
else
  puts 'Suggested VIN(s):'
  puts vin.suggestions.join("\n")
end

vin.errors.each do |error|
  puts <<~STR
    -- Error --
    Message: #{error.message}
    Position: #{error.position + 1}
  STR
end
