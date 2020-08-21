# frozen_string_literal: true

class Appointment < ActiveRecord::Base
  include Stance::Eventable

  def do_create
    publish_event :created
  end
end
