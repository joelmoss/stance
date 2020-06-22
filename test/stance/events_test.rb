# frozen_string_literal: true

require 'test_helper'

module Stance
  class EventsTest < Minitest::Test
    class NoEvents < Stance::Events; end
    class SomeEvents < Stance::Events; event :something; end

    def test_events_variable
      assert_nil Stance::Events.events
      assert_equal ['something'], SomeEvents.events
      assert_nil NoEvents.events
      assert_equal %w[created cancelled payment.expiring payment.expired], AppointmentEvents.events
    end

    def test_publish_unknown_event
      appointment = Appointment.create

      assert_raises(Stance::EventNotFound) { appointment.publish_event(:nothing) }
    end

    def test_publish_namespaced_event
      appointment = Appointment.create

      assert appointment.publish_event('payment.expiring')
      assert_equal 'Appointment.payment.expired event from class',
                   appointment.publish_event('payment.expired')
    end

    def test_publish_event
      appointment = Appointment.create

      assert appointment.publish_event(:created)
      assert_equal 'created', Stance::EventRecord.last.name
      assert_equal appointment, Stance::EventRecord.last.subject
    end

    def test_publish_event_with_class
      appointment = Appointment.create

      assert_equal 'Appointment.cancelled event from class', appointment.publish_event(:cancelled)
    end
  end
end
