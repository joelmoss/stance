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

      assert_equal({ name: 'Joel', last: 'moss', before_created: true }.with_indifferent_access,
                   appointment.events.last.metadata)
    end

    def test_singleton_event
      assert_predicate appointment.publish_event(:singleton).record, :persisted?
      refute_predicate appointment.publish_event(:singleton).record, :persisted?
    end

    def test_event_without_record
      refute appointment.publish_event(:norecord).record
    end

    def test_aborted_callback
      event = appointment.publish_event(:deleted)

      assert event.record.metadata[:before_created]
      refute_predicate event.record, :persisted?
    end

    def test_disabling_events
      Stance.disable 'appointment.created' do
        appointment.do_create
      end

      refute appointment.is_active
    end

    def test_public_method_event
      Appointment.any_instance.stubs(:something).returns(true).once

      assert appointment.publish_event(:after_create)
    end

    def test_class_event
      event = Appointment.publish_event(:class_event)

      assert_equal 'Appointment', event.record.subject_type
    end

    def test_active_record_events
      assert_equal Stance::ActiveRecordCallbacks::CALLBACKS, PostEvents.events.symbolize_keys.keys

      PostEvents::AfterInitialize.any_instance.expects(:do_something).once
      PostEvents::AfterCreate.any_instance.expects(:do_something).once
      PostEvents::AfterCreateCommit.any_instance.expects(:do_something).once

      Post.create title: 'My Post'

      Post::CommentEvents::BeforeCreate.any_instance.expects(:do_something).once
      Post::Comment.create comment: 'awesome!'
    end

    # focus
    # def test_event_order
    #   Post::Comment.create comment: 'awesome!'
    # end
  end
end
