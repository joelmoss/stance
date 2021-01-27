# frozen_string_literal: true

module Stance
  module Eventable
    extend ActiveSupport::Concern

    included do
      has_many :events, as: :subject, class_name: 'Stance::EventRecord'
    end

    class_methods do
      def publish_event(name, metadata = {})
        name = name.to_s
        ensure_event! name

        # Find the Event class - if any - and call it. Falls back to Stance::Event.
        ev = event_class(name).new(name, model_name.name, metadata, events_class.events[name])

        return ev if Stance.disabled_events.include?(ev.full_name)

        events_class.new(ev).run_callbacks(:create) { ev.create }
      end

      private

      # Raise EventNotFound if the class event has not been defined.
      def ensure_event!(name)
        return if events_class.events.one? { |event, options| name == event && options[:class] }

        raise Stance::EventNotFound, "Class event `#{name}` not found"
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

    # Publish an event.
    #
    # Creates an EventRecord with the given `name`, `metadata` and self as the 'subject'.
    #
    # Returns the results of `call`ing the event class.
    def publish_event(name, metadata = {})
      name = name.to_s
      ensure_event! name

      # Find the Event class - if any - and call it. Falls back to Stance::Event.
      ev = event_class(name).new(name, self, metadata, events_class.events[name])

      return ev if Stance.disabled_events.include?(ev.full_name)

      events_class.new(ev).run_callbacks(:create) { ev.create }
    end

    # Raise EventNotFound if the event has not been defined.
    def ensure_event!(name)
      return if events_class.events.one? { |event, options| name == event && !options[:class] }

      raise Stance::EventNotFound, "Event `#{name}` not found"
    end

    def events_class
      @events_class ||= events_class_name.constantize
    end

    def events_class_name
      @events_class_name ||= "#{model_name.name}Events"
    end

    def event_class(name)
      "#{events_class_name}::#{name.tr('.', '/').classify}".constantize
    rescue NameError
      Stance::Event
    end
  end
end
