require_relative './lib/vin'

given_vin_code = ARGV[0]
vin = Vin.new(given_vin_code)

puts "You gave me: #{vin}"
puts "Valid check digit? #{vin.valid?}"
