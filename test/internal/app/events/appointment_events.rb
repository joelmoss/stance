# frozen_string_literal: true

# require 'appointment_events/cancelled'

class AppointmentEvents < Stance::Events
  event :created
  event :cancelled

  event 'payment.expiring'
  event 'payment.expired'

  class Payment
    class Expired < Stance::Event
      def call
        "#{subject.model_name}.#{record} event from class"
      end
    end
  end
end
