# frozen_string_literal: true

module Stance
  class EventRecord < ActiveRecord::Base
    belongs_to :subject, polymorphic: true

    def self.table_name_prefix
      'stance_'
    end

    def to_s
      name
    end

    serialize :metadata, JSON unless connection.adapter_name =~ /postg|mysql/i
  end
end
