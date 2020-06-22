# frozen_string_literal: true

module Stance
  class Events
    class << self
      attr_reader :events

      def event(name)
        @events ||= []
        @events << name.to_s
      end
    end
  end
end
