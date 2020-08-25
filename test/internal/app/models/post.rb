# frozen_string_literal: true

class Post < ActiveRecord::Base
  include Stance::Eventable
  include Stance::ActiveRecordCallbacks
end
