# frozen_string_literal: true

module Stance
  class Event
    include ActiveSupport::Callbacks

    define_callbacks :create
    attr_reader :record, :options

    delegate :subject, :name, to: :record

    class << self
      def before_create(*methods, &block)
        set_callback :create, :before, *methods, &block
      end

      def after_create(*methods, &block)
        set_callback :create, :after, *methods, &block
      end
    end

    def initialize(name, subject, metadata, options)
      @options = { singleton: false }.merge(options)
      @record = Stance::EventRecord.new(name: name, subject: subject, metadata: metadata)
    end

    def create
      return self if singleton_exists?

      Stance::EventRecord.transaction do
        run_callbacks :create do
          record.save
        end
      end

      self
    end

    def full_name
      "#{subject.model_name.singular}.#{name}"
    end

    private

    # Event is a singleton and already exists.
    def singleton_exists?
      options[:singleton] && subject.events.active.exists?(name: name)
    end
  end
end
