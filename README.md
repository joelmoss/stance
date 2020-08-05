# Stance - Simple Events for Rails apps

```ruby
class AppointmentEvents < Stance::Events
  # Define events.
  event :my_event
  event :some_event

  # Namespaced events
  event 'offers.create'
  event 'offers.delete'

  # Singleton event: only one active event with this name can exist for the same subject.
  event :my_event, singleton: true

  # Optionally, create a class for an event.
  class SomeEvent < Stance::Event
    # Return false if you do not want the event to be created.
    def callable?
      false
    end

    def call
      # do something when the event is created. You have access to the event `subject` and `record`.
    end
  end
end

# Publish events from the model
Appointment.find(1).publish_event :some_event
Appointment.find(1).publish_event 'offers.create'
Appointment.find(1).publish_event :event_with_metadata, foo: :bah
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

Run the installer to generate the migration, and then run the migration:

    $ rails g stance:install
    $ rails db:migrate

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
