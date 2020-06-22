# frozen_string_literal: true

module Stance
  class Event
    attr_reader :record, :options

    delegate :subject, :name, to: :record

    def initialize(name, subject, metadata, options)
      @options = { singleton: false }.merge(options)
      @record = Stance::EventRecord.new(name: name, subject: subject, metadata: metadata)
    end

    def valid?
      # If event is a singleton, check there is no other active event with the same name. If there
      # is, return false.
      return false if options[:singleton] && subject.events.active.exists?(name: name)

      callable? && record.save
    end

    def callable?
      true
    end

    def call
      true
    end
  end
end
