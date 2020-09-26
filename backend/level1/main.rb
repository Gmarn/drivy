require 'json'
require 'date'

require './models/car'
require './models/rental'

def create_parking(cars)
  cars.each_with_object({}) do |car, acc|
    acc[car['id'].to_s] = Car.new(car)
  end
end

def calculate_rentals(rentals, parking)
  output = rentals.map do |rental|
    rental.calculate_rental(parking)
  end
  { rentals: output }.to_json
end

file = File.read('./data/input.json')
input = JSON.parse(file)

parking = create_parking(input['cars'])
rentals = input['rentals'].map { |r| Rental.new(r) }

puts calculate_rentals(rentals, parking)
