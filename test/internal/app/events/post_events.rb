# frozen_string_literal: true

class PostEvents < Stance::Events
  include Stance::ActiveRecordEvents

  class AfterInitialize < Stance::Event
    def do_something; end
  end

  class AfterCreate < Stance::Event
    def do_something; end
  end

  class AfterCreateCommit < Stance::Event
    def do_something; end
  end
end
