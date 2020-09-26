require 'json'
require 'date'

require './models/car'
require './models/rental'
require './models/commission'

def create_parking(cars)
  cars.each_with_object({}) do |car, acc|
    acc[car['id'].to_s] = Car.new(car)
  end
end

def calculate_rentals(rentals, parking)
  output = rentals.map do |rental|
    details = rental.calculate_rental(parking)
    commission_input = { days: rental.rental_days, price: details[:price] }
    details[:commission] = Commission.new(commission_input).calculate_commission
    details
  end
  { rentals: output }.to_json
end

file = File.read('./data/input.json')
input = JSON.parse(file)

parking = create_parking(input['cars'])
rentals = input['rentals'].map { |r| Rental.new(r) }

puts calculate_rentals(rentals, parking)
puts rentals
