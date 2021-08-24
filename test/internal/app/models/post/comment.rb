class Post::Comment < ActiveRecord::Base
  include Stance::Eventable
  include Stance::ActiveRecordCallbacks
end
