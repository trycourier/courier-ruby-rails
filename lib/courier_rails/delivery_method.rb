module CourierRails
  class DeliveryMethod
    require "trycourier"
    require "securerandom"

    attr_accessor :settings, :payload, :response

    def initialize(options = {})
      @settings = options
    end

    def deliver!(mail)
      @payload = {}

      courier_data = find_courier_data_from mail

      prepare_event_from courier_data
      prepare_recipient_from mail, courier_data
      prepare_profile_from mail, courier_data
      prepare_data_from courier_data
      prepare_brand_from courier_data

      perfom_send_request
    end

    private

    def client
      ## TODO: Allow passed in Courier Data?
      @client = Courier::Client.new CourierRails.configuration.api_key
    end

    def find_courier_data_from(mail)
      mail.courier_data
    end

    def prepare_event_from(courier_data)
      if courier_data.has_key?(:event)
        @payload["event"] = courier_data[:event]
      else
        raise StandardError, "Must specify :event key in courier_data."
      end
    end

    def prepare_recipient_from(_mail, courier_data)
      @payload["recipient"] = if courier_data.has_key?(:recipient)
        courier_data[:recipient]
      else
        SecureRandom.uuid
      end
    end

    def prepare_profile_from(mail, courier_data)
      profile = {}
      profile = courier_data[:profile] if courier_data.has_key?(:profile)

      profile[:email] = mail.to.first unless mail.to.nil?

      @payload["profile"] = profile unless profile.empty?
    end

    def prepare_data_from(courier_data)
      @payload["data"] = courier_data[:data] if courier_data.has_key?(:data)
    end

    def prepare_brand_from(courier_data)
      @payload["brand"] = courier_data[:brand] if courier_data.has_key?(:brand)
    end

    def perfom_send_request
      client.send(@payload)
    end
  end
end
