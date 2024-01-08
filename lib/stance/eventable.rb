# frozen_string_literal: true

module Stance
  module Eventable
    extend ActiveSupport::Concern

    included do
      has_many :events, as: :subject, class_name: 'Stance::EventRecord' if respond_to?(:has_many)
    end

    class_methods do
      # An event class may also exist in one or more namespaces (see `Stance.config.namespaces`).
      # The event will be published to all classes that define the event class, and the class which
      # defined the event takes priority.
      def publish_event(name, metadata = {}, subject = self)
        name = name.to_s
        subject.ensure_event! name

        # Find the Event class - if any - and initialize it. Falls back to Stance::Event.
        ev = subject.event_class(name)
                    .new(name, subject, metadata, subject.events_class.events[name])

        return ev if Stance.disabled_events.include?(ev.full_name)

        subject.events_class.new(ev).run_callbacks(:create) { ev.create }
      end

      # Raise EventNotFound if the class event has not been defined.
      def ensure_event!(name)
        return if events_class.events.one? { |event, options| name == event && options[:class] }

        raise Stance::EventNotFound, "Class event `#{name}` not found"
      end

      def events_class
        @events_class ||= events_class_name.constantize
      end

      def events_class_name
        @events_class_name ||= "#{name}Events"
      end

      def event_class(name)
        name.constantize
      rescue NameError
        Stance::Event
      end
    end

    # Publish an event.
    #
    # Creates an EventRecord with the given `name`, `metadata` and self as the 'subject'.
    #
    # Returns the results of `call`ing the event class.
    def publish_event(name, metadata = {})
      self.class.publish_event name, metadata, self
    end

    # Raise EventNotFound if the event has not been defined.
    def ensure_event!(name)
      return if events_class.events.one? { |event, options| name == event && !options[:class] }

      raise Stance::EventNotFound, "Event `#{name}` not found in #{events_class}"
    end

    def events_class
      @events_class ||= events_class_name.constantize
    end

    def events_class_name
      @events_class_name ||= "#{self.class.name}Events"
    end

    # The class which defines the event. There will be only one.
    def event_class(name)
      "#{events_class_name}::#{name.tr('.', '/').classify}".constantize
    rescue NameError
      Stance::Event
    end
  end
end
