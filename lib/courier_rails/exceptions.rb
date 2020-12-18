module CourierRails
  class DeliveryException < StandardError
    def initialize(response)
      super(response)
    end
  end
end
