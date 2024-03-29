# frozen_string_literal: true

class AppointmentEvents < Stance::Events
  class Cancelled < Stance::Event
    def create
      "#{subject.model_name}.#{record} event from class"
    end
  end
end
