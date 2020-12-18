# frozen_string_literal: true

require "webmock/rspec"
require "rails"
require "action_mailer"
require "courier_rails"

RSpec.configure do |config|
  config.before(:all) do
    ActionMailer::Base.include CourierRails::DataOptions
  end

  config.before(:each) do |example|
    if example.metadata[:skip_configure]
      CourierRails.configuration = nil # Reset configuration
    else
      CourierRails.configure do |c|
        c.api_key = "TESTAUTHTOKEN1234"
      end
    end
    uri = URI.join("https://api.trycourier.app/", "send") # Future base endpoint will be configurable
    stub_request(:any, uri.to_s)
      .to_return(body: "{\"messageId\": \"1-5e2b2615-05efbb3acab9172f88dd3f6f\"}", status: 200)
  end
end

# A default mailer to generate the mail object
class Mailer < ActionMailer::Base
  default body: "not used"

  def test_email(options = {})
    mail(options)
  end
end
