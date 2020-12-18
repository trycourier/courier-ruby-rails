# CourierRails

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/courier_rails`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'courier_rails'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install courier_rails

## Configuration
Create a Courier Authentication Token for your application. By default, the gem will look for this key in your environment, under the  variable `COURIER_AUTH_TOKEN`. You can override this key by setting it manually in the file `config/initializers/courier_rails.rb`:

```ruby
CourierRails.configure do |c|
  c.api_key = 'your-auth-token'
end
```

Then, edit `config/application.rb` or `config/environments/$ENVIRONMENT.rb` and add/change the following to the ActionMailer configuration:

```ruby
config.action_mailer.delivery_method = :courier_rails
```

## Usage
Normal ActionMailer usage will now send notifications from the Courier template designer, using the Courier API:
```ruby
mail(to: "jane@doe.com", body: "not used", courier_data:data)
```

The "body" parameter is required for ActionMailer, even though the email body is already described by the notification designer. You can also add ```default body: not used``` to the top of your mailer instead of this parameter.

The elements of "courier_data" are described below:

### event (required)
The unique identification key of a template to be sent. If the notification is mapped to an event key, use the event key here instead.

### recipient (optional)
The unique identification key attached to a recipient and their profile. If empty, the code will auto-generate a unique key. 

### profile (optional)
An object that includes the profile data attached to this message. For example,
```ruby
c_data={
    event: "your.event.key"
    profile:{
        phone_number: "555-123-4567",
        name: "Jane Doe"
        email: "jane@doe.com"
        ...
    }
}
mail(body: "not used", courier_data: c_data)
```
As shown above, the recipient's email can be set inside of the profile instead of using the ActionMailer ```to:"email"``` parameter. When both are used, however, the "to" parameter overrides the profile email.

### data (optional)
An object that includes any data you want to pass to a Courier template. The data will populate the corresponding template variables.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/courier_rails. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/courier_rails/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the CourierRails project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/courier_rails/blob/master/CODE_OF_CONDUCT.md).
