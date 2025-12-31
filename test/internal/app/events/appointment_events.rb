# frozen_string_literal: true

class AppointmentEvents < Stance::Events
  before_create do
    event.record.metadata = event.record.metadata.merge(before_created: true) if event.record
  end

  event :created
  event :cancelled
  event :deleted
  event :norecord, record: false
  event :after_create, record: false

  event 'payment.expiring'

  event :class_event, class: true
  event :singleton, singleton: true

  class Created < Stance::Event
    before_create do
      subject.update is_active: true
    end

    private

    def bar
      raise
    end
  end

  class Deleted < Stance::Event
    before_create do
      throw :abort
    end

    private

    def bar
      raise
    end
  end

  class AfterCreate < Stance::Event
    before_create do
      subject.before_something
    end

    after_create do
      subject.after_something
    end

    def do_something
      subject.something
    end

    def self.foo
      raise
    end

    private

    def bar
      raise
    end
  end
end
