class Car
  def initialize(input)
    @id = input['id']
    @price_per_day = input['price_per_day']
    @price_per_km = input['price_per_km']
  end

  def prices
    { per_km: @price_per_km, per_day: @price_per_day }
  end
end
