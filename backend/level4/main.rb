require 'json'
require 'date'

require './models/car'
require './models/rental'
require './models/commission'

ACTORS = {
  driver: 'debit',
  owner: 'credit',
  drivy: 'credit',
  insurance: 'credit',
  assistance: 'credit'
}.freeze

def create_parking(cars)
  cars.each_with_object({}) do |car, acc|
    acc[car['id'].to_s] = Car.new(car)
  end
end

def resolve_commission(days, price)
  commission_input = { days: days, price: price }
  Commission.new(commission_input).calculate_commission
end

def create_action(actor, type, amount)
  {
    who: actor.to_s,
    type: type,
    amount: amount
  }
end

def define_amount(actor, rental_details)
  case actor
  when :driver then rental_details[:price]
  when :owner then rental_details[:commission][:owner_payment]
  when :drivy then rental_details[:commission][:drivy_fee]
  when :insurance then rental_details[:commission][:insurance_fee]
  when :assistance then rental_details[:commission][:assistance_fee]
  else 'This actor do not exist for the moment'
  end
end

def action_distributor(rental_details)
  ACTORS.map do |actor, type|
    amount = define_amount(actor, rental_details)
    create_action(actor, type, amount)
  end
end

def generate_output(rentals, parking)
  output = rentals.map do |rental|
    details = rental.calculate_rental(parking)
    details[:commission] = resolve_commission(rental.rental_days, details[:price])
    details[:actions] = action_distributor(details)
    details
  end
  { rentals: output.map { |s| s.slice(:id, :actions) } }.to_json
end

file = File.read('./data/input.json')
input = JSON.parse(file)

parking = create_parking(input['cars'])
rentals = input['rentals'].map { |r| Rental.new(r) }

puts generate_output(rentals, parking)
