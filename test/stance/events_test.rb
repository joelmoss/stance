# frozen_string_literal: true

require 'test_helper'

module Stance
  class EventsTest < Minitest::Test
    class NoEvents < Stance::Events; end
    class SomeEvents < Stance::Events; event :something; end
    class InheritedEvents < SomeEvents; event :something_else; end
    class MoreInheritedEvents < InheritedEvents; event :something_more; end

    def test_events_variable
      assert_equal({}, Stance::Events.events)
      assert_equal ['something'], SomeEvents.events.keys
      assert_equal({}, NoEvents.events)
      assert_equal %w[created cancelled deleted norecord after_create payment.expiring class_event
                      singleton], AppointmentEvents.events.keys
    end

    def test_events_callback
      appointment = Appointment.create

      assert appointment.publish_event(:deleted).record.metadata[:before_created]
    end

    def test_inherited_events
      assert_equal %w[something], SomeEvents.events.keys
      assert_equal %w[something something_else], InheritedEvents.events.keys
      assert_equal %w[something something_else something_more], MoreInheritedEvents.events.keys
    end

    def test_duplicated_inherited_events
      assert_raises Stance::DuplicateEvent do
        Class.new(InheritedEvents) do
          event :something_else, foo: :bar
        end
      end
    end
  end
end
