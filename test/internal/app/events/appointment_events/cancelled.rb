# frozen_string_literal: true

class AppointmentEvents < Stance::Events
  class Cancelled < Stance::Event
    def call
      "#{record} event class"
    end
  end
end
