# frozen_string_literal: true

require 'test_helper'

module Stance
  class EventsTest < Minitest::Test
    class NoEvents < Stance::Events; end
    class SomeEvents < Stance::Events; event :something; end

    def test_events_variable
      assert_nil Stance::Events.events
      assert_equal [:something], SomeEvents.events
      assert_nil NoEvents.events
      assert_equal %i[created cancelled], AppointmentEvents.events
    end

    def test_publish_unknown_event
      rec = Appointment.create

      assert_raises(Stance::EventNotFound) { rec.publish_event(:nothing) }
    end

    def test_publish_event
      rec = Appointment.create

      assert rec.publish_event(:created)
      assert_equal 'created', Stance::EventRecord.last.name
    end

    def test_publish_event_with_class
      rec = Appointment.create

      assert_equal 'cancelled event class', rec.publish_event(:cancelled)
    end
  end
end
