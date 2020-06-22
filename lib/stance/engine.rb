# frozen_string_literal: true

require 'rails'

module Stance
  class Engine < ::Rails::Engine
    isolate_namespace Stance

    initializer 'active_record.include_event_concern' do
      ActiveSupport.on_load(:active_record) do
        ActiveRecord::Base.include Stance::EventConcern
      end
    end
  end
end
