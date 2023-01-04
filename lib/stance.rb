# frozen_string_literal: true

require 'stance/version'
require 'stance/engine'

module Stance
  class Error < StandardError; end
  class EventNotFound < Error; end
  class DuplicateEvent < Error; end

  mattr_accessor :disabled_events
  @@disabled_events = []

  def self.disable(*events)
    disabled_events.concat events
    yield
  ensure
    self.disabled_events -= events
  end

  autoload :Events, 'stance/events'
  autoload :Event, 'stance/event'
  autoload :Eventable, 'stance/eventable'
  autoload :ActiveRecordCallbacks, 'stance/active_record_callbacks'
  autoload :ActiveRecordEvents, 'stance/active_record_events'
end
