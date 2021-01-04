require_relative "spec_helper"

describe CourierRails::DeliveryMethod do
  before(:each) do
    @delivery_method = CourierRails::DeliveryMethod.new
  end

  context "Event" do
    it "accepts the event to use" do
      test_email = Mailer.test_email courier_data: {event: "TEST_EVENT"}

      @delivery_method.deliver!(test_email)

      expect(@delivery_method.payload["event"]).to eq("TEST_EVENT")
    end

    it "raises exception if event is missing" do
      test_email = Mailer.test_email

      expect { @delivery_method.deliver!(test_email) }.to raise_exception(StandardError)
    end
  end

  context "Recipient" do
    it "accepts the recipient to use" do
      test_email = Mailer.test_email courier_data: {event: "TEST_EVENT", recipient: "TEST_RECIPIENT"}

      @delivery_method.deliver!(test_email)

      expect(@delivery_method.payload["recipient"]).to eq("TEST_RECIPIENT")
    end

    it "converts provided recipient to a string" do
      test_email = Mailer.test_email courier_data: {event: "TEST_EVENT", recipient: 12345}

      @delivery_method.deliver!(test_email)

      expect(@delivery_method.payload["recipient"]).to eq("12345")
    end

    it "uses email from to if not provided" do
      test_email = Mailer.test_email to: "to@example.com", courier_data: {event: "TEST_EVENT"}

      @delivery_method.deliver!(test_email)

      expect(@delivery_method.payload["recipient"]).to eq("to@example.com")
    end

    it "generates a recipient if not provided and no to" do
      test_email = Mailer.test_email courier_data: {event: "TEST_EVENT"}

      @delivery_method.deliver!(test_email)

      expect(@delivery_method.payload["recipient"]).to_not be_nil
    end
  end

  context "Profile" do
    it "accepts the profile to use" do
      test_email = Mailer.test_email courier_data: {event: "TEST_EVENT", profile: {phone_number: "555-555-5555"}}

      @delivery_method.deliver!(test_email)

      expect(@delivery_method.payload["profile"][:phone_number]).to eq("555-555-5555")
    end

    it "accepts to as email in profile" do
      test_email = Mailer.test_email to: "to@example.com", courier_data: {event: "TEST_EVENT"}

      @delivery_method.deliver!(test_email)

      expect(@delivery_method.payload["profile"][:email]).to eq("to@example.com")
    end
  end

  context "Data" do
    it "accepts the data to use" do
      test_email = Mailer.test_email courier_data: {event: "TEST_EVENT", data: {hello: "test"}}

      @delivery_method.deliver!(test_email)

      expect(@delivery_method.payload["data"][:hello]).to eq("test")
    end
  end

  context "Brand" do
    it "accepts the brand to use" do
      test_email = Mailer.test_email courier_data: {event: "TEST_EVENT", brand: "TEST_BRAND"}

      @delivery_method.deliver!(test_email)

      expect(@delivery_method.payload["brand"]).to eq("TEST_BRAND")
    end
  end
end
