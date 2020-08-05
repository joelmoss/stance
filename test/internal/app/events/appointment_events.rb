# frozen_string_literal: true

class AppointmentEvents < Stance::Events
  before_create do
    event.record.metadata = event.record.metadata.merge(before_created: true)
  end

  event :created
  event :cancelled
  event :deleted

  event 'payment.expiring'

  event :singleton, singleton: true

  class Deleted < Stance::Event
    before_create do
      throw :abort
    end
  end
end
