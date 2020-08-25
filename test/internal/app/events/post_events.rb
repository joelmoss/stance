# frozen_string_literal: true

class PostEvents < Stance::Events
  include Stance::ActiveRecordEvents

  class AfterCreate < Stance::Event
    def do_something; end
  end
end
