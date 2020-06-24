# frozen_string_literal: true

require 'multi_json'

class JSONWithIndifferentAccess
  def self.load(str)
    return str unless str

    obj = HashWithIndifferentAccess.new(MultiJson.load(str))
    obj.freeze
    obj
  end

  def self.dump(obj)
    MultiJson.dump(obj)
  end
end

module Stance
  class EventRecord < ActiveRecord::Base
    belongs_to :subject, polymorphic: true

    scope :active, -> { where dismissed_at: nil }
    scope :dismissed, -> { where.not dismissed_at: nil }

    def self.table_name_prefix
      'stance_'
    end

    def self.dismiss_all
      active.each(&:dismiss)
    end

    def to_s
      name
    end

    def event_class_name
      @event_class_name ||= "#{subject.model_name.name}Events::#{name.tr('.', '/').classify}"
    end

    def event_class
      @event_class ||= event_class_name.constantize
    end

    def dismissed?
      dismissed_at.present?
    end

    def active?
      !dismissed?
    end

    def dismiss
      update_attribute :dismissed_at, Time.current
    end

    unless connection.adapter_name =~ /postg|mysql/i
      serialize :metadata, ::JSONWithIndifferentAccess
    end
  end
end
