# frozen_string_literal: true

require 'stance/version'
require 'stance/engine'

module Stance
  class EventNotFound < StandardError; end

  autoload :Events, 'stance/events'
  autoload :Event, 'stance/event'
  autoload :EventConcern, 'stance/event_concern'
end
