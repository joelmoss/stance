# frozen_string_literal: true

module Stance
  module ActiveRecordCallbacks
    extend ActiveSupport::Concern

    CALLBACKS = %i[before_validation after_validation before_save before_create
                   after_create before_update after_update before_destroy after_destroy after_save
                   after_touch after_commit after_save_commit after_create_commit
                   after_update_commit after_destroy_commit after_rollback].freeze

    included do
      CALLBACKS.each do |cb|
        send(cb) { publish_event cb }
      end
    end
  end
end
