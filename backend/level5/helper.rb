module Helper
  ACTORS = {
    driver: 'debit',
    owner: 'credit',
    drivy: 'credit',
    insurance: 'credit',
    assistance: 'credit'
  }.freeze

  def generate_output(rentals, parking, options)
    output = rentals.map do |rental|
      details = rental.calculate_rental(parking)
      details[:days] = rental.rental_days
      details[:commission] = resolve_commission(rental.rental_days, details[:price])
      details[:options] = [options[rental.id.to_s]].flatten.compact # To handle case there no options
      details[:actions] = action_distributor(details)
      details[:options].map! { |option| option.type } unless details[:options].empty?
      details
    end
    { rentals: output.map { |s| s.slice(:id, :options, :actions) } }.to_json
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

  def sum_option_cost(options, days, actor)
    options.sum { |option| option.cost_by_actor(days, actor) }
  end

  def define_amount(actor, rental_details)
    case actor
    when :driver
      rental_details[:price] +
        sum_option_cost(rental_details[:options], rental_details[:days], actor)
    when :owner
      rental_details[:commission][:owner_payment] +
        sum_option_cost(rental_details[:options], rental_details[:days], actor)
    when :drivy
      rental_details[:commission][:drivy_fee] +
        sum_option_cost(rental_details[:options], rental_details[:days], actor)
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
end
