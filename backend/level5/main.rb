require 'json'
require 'date'

require './models/car'
require './models/rental'
require './models/commission'
require './models/option'
require './helper'

include Helper

def create_parking(cars)
  cars.each_with_object({}) do |car, acc|
    acc[car['id'].to_s] = Car.new(car)
  end
end

def option_construtor(options)
  options.each_with_object({}) do |option, acc|
    acc[option['rental_id'].to_s] = [] if acc[option['rental_id'].to_s].nil?
    acc[option['rental_id'].to_s] << Option.new(option)
  end
end

file = File.read('./data/input.json')
input = JSON.parse(file)

parking = create_parking(input['cars'])
rentals = input['rentals'].map { |r| Rental.new(r) }
options = option_construtor(input['options'])

json = Helper.generate_output(rentals, parking, options)
puts json
