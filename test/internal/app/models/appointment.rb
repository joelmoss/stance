# frozen_string_literal: true

class Appointment < ActiveRecord::Base
  include Stance::Eventable
end
