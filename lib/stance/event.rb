# frozen_string_literal: true

module Stance
  class Event
    attr_reader :record

    def initialize(record)
      @record = record
    end
  end
end
