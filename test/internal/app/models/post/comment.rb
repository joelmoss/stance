# frozen_string_literal: true

class Post
  class Comment < ActiveRecord::Base
    include Stance::Eventable
    include Stance::ActiveRecordCallbacks
  end
end
