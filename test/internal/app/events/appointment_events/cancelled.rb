# frozen_string_literal: true

class AppointmentEvents < Stance::Events
  class Cancelled < Stance::Event
    def create
      super
      "#{subject.model_name}.#{record} event from class"
    end
  end
end
