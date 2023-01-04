# frozen_string_literal: true

module Stance
  class Events
    include ActiveSupport::Callbacks

    attr_reader :event

    define_callbacks :create

    class << self
      attr_accessor :events

      def inherited(child)
        @events ||= {}
        child.events ||= @events.dup
        super
      end

      def event(name, options = {})
        @events ||= {}
        sname = name.to_s

        raise DuplicateEvent, "Cannot redefine event :#{sname} on #{self}" if @events.key?(sname)

        @events[sname] = options
      end

      def before_create(*methods, &block)
        set_callback :create, :before, *methods, &block
      end

      def after_create(*methods, &block)
        set_callback :create, :after, *methods, &block
      end
    end

    def initialize(event)
      @event = event
    end
  end
end
