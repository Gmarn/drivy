class Rental
  def initialize(input)
    @id = input['id']
    @car_id = input['car_id']
    @start_date = Date.parse(input['start_date'])
    @end_date = Date.parse(input['end_date'])
    @distance = input['distance']
  end

  def calculate_rental(parking)
    # Could be good validate car is in the parking
    car = parking[@car_id.to_s]
    {
      id: @id,
      price: distance_price(car.prices[:per_km]) + day_price(car.prices[:per_day])
    }
  end

  private

  def distance_price(price_per_km)
    @distance * price_per_km
  end

  def day_price(price_per_day)
    # Could be interesting some validation on days to not have negative
    # Need to add 1 because end day count
    days = (@end_date - @start_date + 1).to_i
    days * price_per_day
  end
end
