# Courier Rails

This gem provides seamless integration of Courier with ActionMailer. It provides a `delivery_method` based upon the [Courier API](https://docs.courier.com/reference), and makes getting setup and sending notifications in a Rails app using Courier easier.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'courier_rails'
```

And then execute:

    $ bundle install

## Configuration

Retrieve your [Courier Authentication Token](https://app.courier.com/settings/api-keys). By default, the gem will look for your token in your environment, with the key `COURIER_AUTH_TOKEN`. You can override this key by setting it manually in the file `config/initializers/courier_rails.rb`:

```ruby
CourierRails.configure do |c|
  c.api_key = 'your-auth-token'
end
```

Then, edit `config/application.rb` or `config/environments/$ENVIRONMENT.rb` and add/change the following to the ActionMailer configuration:

```ruby
config.action_mailer.delivery_method = :courier
```

## Usage

Normal ActionMailer usage will now send notifications from the Courier template designer, using the Courier API:

```ruby
data = {
    event: "EVENT_ID",
    recipient: "RECIPIENT_ID",
    data: {
        hello: "Rails!"
    }
}

mail(to: "jane@doe.com", body: CourierRails::DEFAULT_COURIER_BODY, subject: CourierRails::USE_COURIER_SUBJECT, courier_data: data)
```

The `body` parameter is required for ActionMailer, even though the email body is already described by the notification designer. You can also add `default body: CourierRails::DEFAULT_COURIER_BODY` to the top of your mailer instead of this parameter.

Since the `subject` will never be nil, we need to provide it with `CourierRails::USE_COURIER_SUBJECT` to ensure it uses the subject from the Courier template. Any value you pass as the subject will becoming the subject of the message. You can also add `default subject: CourierRails::USE_COURIER_SUBJECT` to the top of your mailer instead of this parameter.

The elements of `courier_data` are described below:

### event (required)

The unique identification key of a notification template to be sent. If the notification is mapped to an event key, use the event key here instead.

### recipient (optional)

The unique identification key attached to a recipient and their profile. The value should be a string, all other values will be converted to a string. If empty, the code will either use the email provided in the to or auto-generate a unique key.

### profile (optional)

An object that includes the profile data attached to this message. For example,

```ruby
c_data={
    event: "your.event.key"
    profile: {
        phone_number: "555-123-4567",
        name: "Jane Doe"
        email: "jane@doe.com"
        ...
    }
}
mail(body: CourierRails::DEFAULT_COURIER_BODY, courier_data: c_data)
```

As shown above, the recipient's email can be set inside of the profile instead of using the ActionMailer `to:"email"` parameter. When both are used, however, the "to" parameter overrides the profile email.

### data (optional)

An object that includes any data you want to pass to a Courier template. The data will populate the corresponding template variables.

When calling the `deliver!` method on the mail object returned from your mailer. `CourierRails` provides the response data directly back from Courier in a `Courier::SendResponse` object.

```ruby
result = MyMailer.welcome_message(user).deliver!
puts result.code # Status Code
puts result.message_id # Message ID
```

## Email Overrides

Providing the following parameters to the mailer object will override values used by Courier:

- `cc` - Carbon Copy Email Address
- `bcc` - Blind Carbon Copy Email Address
- `from` - From Email Address
- `reply_to` - Reply To Email Address
- `subject` - Email Subject

If you provide ERB email templates, these will replace the email body used for the email and providing `body: CourierRails::DEFAULT_COURIER_BODY` in the mailer object is no longer necessary.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/trycourier/courier_rails. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/trycourier/courier_rails/blob/master/CODE_OF_CONDUCT.md). See [CONTRIBUTING.md](CONTRIBUTING.md) for more info.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the CourierRails project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/trycourier/courier_rails/blob/master/CODE_OF_CONDUCT.md).
