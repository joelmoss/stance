# frozen_string_literal: true

module Stance
  module Eventable
    extend ActiveSupport::Concern

    included do
      has_many :events, as: :subject, class_name: 'Stance::EventRecord'
    end

    # Publish an event.
    #
    # Creates an EventRecord with the given `name`, `metadata` and self as the 'subject'.
    #
    # Returns the results of `call`ing the event class.
    def publish_event(name, metadata = {})
      name = name.to_s
      ensure_event! name

      # Find the Event class - if any - and call it. Falls back to Stance::Event.
      event_class_name = "#{events_class_name}::#{name.to_s.tr('.', '/').classify}"
      ev = event_class(event_class_name).new(name, self, metadata, events_class.events[name])

      ev.create
    end

    private

    # Raise EventNotFound if the event has not been defined.
    def ensure_event!(name)
      return if events_class.events.keys.include?(name)

      raise Stance::EventNotFound, "Event `#{name}` not found"
    end

    def events_class
      @events_class ||= events_class_name.constantize
    end

    def events_class_name
      @events_class_name ||= "#{model_name.name}Events"
    end

    def event_class(name)
      name.constantize
    rescue NameError
      Stance::Event
    end
  end
end
