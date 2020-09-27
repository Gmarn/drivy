class Option
  GPS_PRICE = 500
  BABY_SITE_PRICE = 200
  DRIVY_INSURANCE_PRICE = 1000

  def initialize(input)
    @id = input['id']
    @rental_id = input['rental_id']
    @type = input['type']
  end


  def cost_by_actor(days, actor)
    case @type
    when 'gps'
      return GPS_PRICE * days if actor == :driver || actor == :owner
      0
    when 'baby_seat'
      return BABY_SITE_PRICE * days if actor == :driver || actor == :owner
      0
    when 'additional_insurance'
      return DRIVY_INSURANCE_PRICE * days if actor == :driver || actor == :drivy
      0
    else 'This option is not availabe'
    end
  end

  def cost(days)
    case @type
    when 'gps' then GPS_PRICE * days
    when 'baby_seat' then BABY_SITE_PRICE * days
    when 'additional_insurance' then DRIVY_INSURANCE_PRICE * days
    else 'This option is not availabe'
    end
  end

  def type
    @type
  end
end
