class Commission
  COMMISSION_PART = 0.3
  ASSISTANCE_PER_DAY = 100
  INSURANCE_PART = 0.5

  def initialize(input)
    @total_days = input[:days]
    @total_price = input[:price]
    @total_commission = @total_price * COMMISSION_PART
  end

  def calculate_commission
    # TODO: Set up exception or warning when drivy fee is negative
    insurance_fee = @total_commission * INSURANCE_PART
    assistance_fee = @total_days * ASSISTANCE_PER_DAY
    {
      insurance_fee: insurance_fee,
      assistance_fee: assistance_fee,
      drivy_fee: @total_commission - (insurance_fee + assistance_fee)
    }
  end
end
