# Stance

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/stance`. To experiment with that code, run `bin/console` for an interactive prompt.

```ruby
class AppointmentEvents < Stance::Events
  # Define events.
  event :my_event, notify: :client
  event :some_event, dismissed_on: :some_action, after: 2.hours
  event :another_event

  # Namespaced event
  event 'offers.create'

  # Optionally, create a class for an event.
  class SomeEvent < Stance::Event
    notify :client, :therapist do
      dismissed_on :some_event, after: 2.hours
      dismissable_by :client
    end
  end

  class Offers::SomeEvent < Stance::Event
    notify :client, :therapist do
      dismissed_on :some_event, after: 2.hours
      dismissable_by :client
    end
  end
end

# Publish event from the model
Appointment.find(1).publish_event :some_event

# MAYBE: Or for events that are not model backed.
Evt.publish 'amazing_event'
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'stance'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install stance

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/joelmoss/stance. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/joelmoss/stance/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Stance project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/joelmoss/stance/blob/master/CODE_OF_CONDUCT.md).
