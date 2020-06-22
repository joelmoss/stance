# frozen_string_literal: true

# require 'appointment_events/cancelled'

class AppointmentEvents < Stance::Events
  event :created
  event :cancelled
end
