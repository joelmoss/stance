# frozen_string_literal: true

module Stance
  module EventConcern
    # Publish an event.
    #
    # Creates an Event record with the given `name` and `metadata`.
    def publish_event(name)
      # Raise EventNotFound if the event has not been defined.
      raise Stance::EventNotFound, "Event `#{name}` not found" unless events.include?(name.to_sym)

      record = Stance::EventRecord.create(name: name)

      # Find the Event class - if any - and call it.
      event_klass_name = "#{events_class_name}::#{name.to_s.classify}"

      begin
        event_klass = event_klass_name.constantize
      rescue NameError
        return true
      end

      event_klass ? event_klass.new(record).call : true
    end

    private

    def events_class
      @events_class ||= events_class_name.constantize
    end

    def events_class_name
      @events_class_name ||= "#{model_name.name}Events"
    end

    def events
      events_class.events
    end
  end
end
