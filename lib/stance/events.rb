# frozen_string_literal: true

module Stance
  class Events
    class << self
      attr_reader :events

      def event(name, options = {})
        @events ||= {}
        @events[name.to_s] = options
      end
    end
  end
end
