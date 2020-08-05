# frozen_string_literal: true

require 'test_helper'
require 'active_support/core_ext/hash/indifferent_access'

module Stance
  class EventTest < Minitest::Test
    def appointment
      @appointment ||= Appointment.create
    end

    def test_publish_unknown_event
      assert_raises(Stance::EventNotFound) { appointment.publish_event(:nothing) }
    end

    def test_returns_event
      assert_instance_of Stance::Event, appointment.publish_event(:created)
      assert_instance_of Stance::Event, appointment.publish_event('payment.expiring')
    end

    def test_publish_event
      appointment.publish_event :created

      assert_equal 'created', appointment.events.last.name
      assert_equal appointment, appointment.events.last.subject
    end

    def test_publish_event_with_class
      assert_equal 'Appointment.cancelled event from class', appointment.publish_event(:cancelled)
    end

    def test_publish_event_with_metadata
      appointment.publish_event 'payment.expiring', name: 'Joel', 'last' => 'moss'

      assert_equal({ name: 'Joel', 'last': 'moss' }.with_indifferent_access,
                   appointment.events.last.metadata)
    end

    def test_singleton_event
      assert appointment.publish_event(:singleton).record.persisted?
      refute appointment.publish_event(:singleton).record.persisted?
    end

    def test_aborted_callback
      refute appointment.publish_event(:deleted).record.persisted?
    end
  end
end
