# frozen_string_literal: true

module Stance
  module ActiveRecordEvents
    extend ActiveSupport::Concern

    included do
      with_options record: false do
        Stance::ActiveRecordCallbacks::CALLBACKS.each { |ev| event(ev) }
      end
    end
  end
end
