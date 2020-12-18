require_relative "spec_helper"

describe "CourierRails configuration" do
  let(:delivery_method) { CourierRails::DeliveryMethod.new }

  describe "#configuration" do
    it "creates a new configuration + defaults if #configure is never called", skip_configure: true do
      config = CourierRails.configuration
      expect(config).to_not be_nil
    end
  end
end
