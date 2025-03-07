# frozen_string_literal: true

class Post
  class CommentEvents
    class BeforeCreate < Stance::Event
      def do_something; end

      private

      def private_method; end
    end
  end
end
