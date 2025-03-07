# frozen_string_literal: true

class Post
  class CommentEvents < Stance::Events
    include Stance::ActiveRecordEvents
  end
end
