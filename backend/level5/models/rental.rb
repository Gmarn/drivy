class Rental
  def initialize(input)
    @id = input['id']
    @car_id = input['car_id']
    @distance = input['distance']
    @start_date = Date.parse(input['start_date'])
    @end_date = Date.parse(input['end_date'])
    @rental_days = rental_days
  end

  def calculate_rental(parking)
    begin
      car = parking[@car_id.to_s]
      raise "Car number #{@car_id} is not in the parking" if car.nil?
      {
        id: @id,
        price: distance_price(car.prices[:per_km]) + day_price_with_discount(car.prices[:per_day])
      }
    rescue Exception => e
      { id: @id, price: e.message }
    end
  end

  def rental_days
    # Need to add 1 because end day count
    (@end_date - @start_date + 1).to_i
  end

  def id
    @id
  end

  private

  def distance_price(price_per_km)
    @distance * price_per_km
  end


  def day_price(days, price)
    # Could be good to define discount constant at the start of the class
    case days
    when 0..1 then price
    when 2..4 then price * 0.9
    when 5..10 then price * 0.7
    else price * 0.5
    end
  end

  def day_price_with_discount(price_per_day)
    raise "For rental #{@id} Start date older than end date" if @rental_days.negative?
    price = 0
    days = @rental_days.dup
    # Far from the best performant way do that because I need to pass throw all day
    while days.positive? do
      price += day_price(days, price_per_day)
      days -= 1
    end
    price
  end
end
