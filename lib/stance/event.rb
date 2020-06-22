# frozen_string_literal: true

module Stance
  class Event
    attr_reader :record, :subject

    delegate :subject, to: :record

    def initialize(record)
      @record = record
    end

    def call
      raise NotImplementedError, '#call must be implemented'
    end
  end
end
