require "json"
require "ostruct"
require "rspec"
require "courier_rails/action_mailer_courier_transformer"

def mockMailObject(obj)
  json = obj.to_json
  JSON.parse(json, object_class: OpenStruct)
end

describe "ActionMailer Courier Transformer" do
  it "handles setting the html_part if it is present in the decoded email" do
    mail = mockMailObject({html_part: {decoded: "<h1>html</h1>"}})
    override = ActionMailerCourierTransformer.new.tranform_email_body_for_override(mail)

    expect(override[:channel][:email][:html])
    expect(override.fetch(:channel).fetch(:email).fetch(:html)).to eq "<h1>html</h1>"
  end

  it "does not set the html_part if it is not present in the decoded email" do
    mail = mockMailObject({text_part: {decoded: "plain text"}})
    override = ActionMailerCourierTransformer.new.tranform_email_body_for_override(mail)

    expect(override[:channel][:email][:html]).to be_nil
  end

  it "handles setting the text_part if it is present in the decoded email" do
    mail = mockMailObject({text_part: {decoded: "plain text"}})
    override = ActionMailerCourierTransformer.new.tranform_email_body_for_override(mail)

    expect(override[:channel][:email][:text])
    expect(override.fetch(:channel).fetch(:email).fetch(:text)).to eq "plain text"
  end

  it "does not set the text_part if it is not present in the decoded email" do
    mail = mockMailObject({html_part: {decoded: "<h1>html</h1>"}})
    override = ActionMailerCourierTransformer.new.tranform_email_body_for_override(mail)

    expect(override[:channel][:email][:text]).to be_nil
  end
end
