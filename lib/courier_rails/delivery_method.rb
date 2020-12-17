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

      result = perfom_send_request

      result
    end

    private

    def client
      ## TODO: Allow passed in Courier Data?
      @client = Courier::Client.new CourierRails.configuration.api_key
    end

    def find_courier_data_from mail
      mail.courier_data
    end

    def prepare_event_from courier_data
      ## TODO: Should error if event is not provided
      @payload["event"] = courier_data[:event]
    end

    def prepare_recipient_from mail, courier_data
      if courier_data.has_key?(:recipient)
        @payload["recipient"] = courier_data[:recipient]
      else
        @payload["recipient"] = SecureRandom.uuid
      end
    end

    def prepare_profile_from mail, courier_data
      profile = {}
      if courier_data.has_key?(:profile)
        profile = courier_data[:profile]
      end

      if !mail.to.nil?
        profile["email"] = mail.to.first
      end

      if !profile.empty?
        @payload["profile"] = profile
      end
    end

    def prepare_data_from courier_data
      if courier_data.has_key?(:data)
        @payload["data"] = courier_data[:data]
      end
    end

    def perfom_send_request
      result = client.send(@payload)

      result
    end

  end
end