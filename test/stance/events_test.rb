# frozen_string_literal: true

require 'test_helper'

module Stance
  class EventsTest < Minitest::Test
    class NoEvents < Stance::Events; end
    class SomeEvents < Stance::Events; event :something; end

    def test_events_variable
      assert_nil Stance::Events.events
      assert_equal ['something'], SomeEvents.events.keys
      assert_nil NoEvents.events
      assert_equal %w[created cancelled deleted norecord after_create payment.expiring singleton],
                   AppointmentEvents.events.keys
    end

    def test_events_callback
      appointment = Appointment.create

      assert appointment.publish_event(:deleted).record.metadata[:before_created]
    end
  end
end
