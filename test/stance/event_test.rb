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

    def test_publish_namespaced_event
      assert appointment.publish_event('payment.expiring')
      assert_equal 'Appointment.payment.expired event from class',
                   appointment.publish_event('payment.expired')
    end

    def test_publish_event
      assert_equal true, appointment.publish_event(:created)
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
      assert_equal true, appointment.publish_event(:singleton)
      assert_equal false, appointment.publish_event(:singleton)
    end

    def test_event_not_callable
      assert_equal false, appointment.publish_event(:deleted)
    end
  end
end
