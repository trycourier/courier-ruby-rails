require "trycourier"
require_relative "spec_helper"

describe CourierRails::DeliveryMethod do
  before(:each) do
    @delivery_method = CourierRails::DeliveryMethod.new
  end

  context "API Response Handling" do
    it "returns result data on success" do
      test_email = Mailer.test_email to: "to@example.com", courier_data: {event: "EVENT_ID"}
      response = @delivery_method.deliver!(test_email)

      expect(response.code).to eq(200)
      expect(response.message_id).to eq("1-5e2b2615-05efbb3acab9172f88dd3f6f")
    end

    it "raises exception on error" do
      uri = URI.join("https://api.trycourier.app/", "send")
      stub_request(:any, uri.to_s)
        .to_return(body: "{\"message\":\"Error Message\",\"type\":\"invalid_request_error\"}", status: 400)

      test_email = Mailer.test_email courier_data: {event: "EVENT_ID"}

      expect { @delivery_method.deliver!(test_email) }.to raise_exception(Courier::ResponseError)
    end
  end
end
