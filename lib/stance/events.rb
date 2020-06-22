# frozen_string_literal: true

module Stance
  class Events
    class << self
      attr_reader :events

      def event(name)
        @events ||= []
        @events << name
        # Rails.autoloaders.log!
        # autoload :AppointmentEvents::Cancelled, 'appointment_events/cancelled'
      end
    end
  end
end
