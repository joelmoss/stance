# frozen_string_literal: true

module Stance
  class Events
    include ActiveSupport::Callbacks

    attr_reader :event

    define_callbacks :create

    class << self
      attr_reader :events

      def event(name, options = {})
        @events ||= {}
        @events[name.to_s] = options
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
