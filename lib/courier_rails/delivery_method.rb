module CourierRails
  class DeliveryMethod
    require "trycourier"
    require "securerandom"
    require "courier_rails/action_mailer_courier_transformer"

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

      prepare_override_from mail

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

    def prepare_recipient_from(mail, courier_data)
      @payload["recipient"] = if courier_data.has_key?(:recipient)
        courier_data[:recipient].to_s
      elsif !mail.to.nil?
        mail.to.first
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

    # mail TODO
    # :subject, :to, :from, :cc, :bcc, :reply_to
    ##
    # "override": {
    #   "channel": {
    #     "email": {
    #       "cc": "seth+cc@courier.com",
    #       "bcc": "seth+bcc@courier.com",
    #       "from": "seth+bcc@courier.com.com",
    #       "replyTo": "seth+replyto@courier.com",
    #       "subject": "muh subject",
    #       "html": "<html><body><div>muh html</div></body></html>",
    #       "text": "muh text"
    #     }
    #   }
    # }
    #
    def prepare_override_from(mail)
      email_override = {
        channel: {
          email: {}
        }
      }

      email_override[:channel][:email][:cc] = mail.cc.first unless mail.cc.nil?
      email_override[:channel][:email][:bcc] = mail.bcc.first unless mail.bcc.nil?
      email_override[:channel][:email][:from] = mail.from.first unless mail.from.nil?
      email_override[:channel][:email][:replyTo] = mail.reply_to.first unless mail.reply_to.nil?
      # mail.subject is never nil, defaults to humanized method name
      email_override[:channel][:email][:subject] = mail.subject unless mail.subject.nil?

      email_override = ActionMailerCourierTransformer.new.tranform_email_body_for_override(mail, email_override)

      @payload[:override] = email_override unless email_override[:channel][:email].empty?
    end

    def perfom_send_request
      client.send(@payload)
    end
  end
end
