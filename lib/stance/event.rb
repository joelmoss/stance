# frozen_string_literal: true

module Stance
  class Event
    include ActiveSupport::Callbacks

    define_callbacks :create
    attr_reader :record, :options, :name

    class << self
      attr_accessor :callback_methods

      def before_create(*methods, &)
        set_callback(:create, :before, *methods, &)
      end

      def after_create(*methods, &)
        set_callback(:create, :after, *methods, &)
      end

      def method_added(method_name)
        super

        return if self == Stance::Event || !method_defined?(method_name, false)

        self.callback_methods ||= []
        self.callback_methods << method_name
      end
    end

    def initialize(name, subject, metadata, options)
      @subject = subject
      @name = name
      @metadata = metadata
      @options = { singleton: false, record: true, class: false }.merge(options)

      attrs = { name:, metadata: }
      if subject.is_a?(ActiveRecord::Base)
        attrs[:subject] = subject
      elsif subject.is_a?(Class) && subject < ActiveRecord::Base
        attrs[:subject_type] = subject.name
      else
        @options[:record] = false
      end

      return unless @options[:record]

      @record = Stance::EventRecord.new(attrs)
    end

    def create
      return self if singleton_exists?

      Stance::EventRecord.transaction do
        run_callbacks :create do
          # Call each public method of the Event class if a custom class.
          if self.class.name != 'Stance::Event'
            Rails.logger.debug "Event: #{full_name}"

            self.class.callback_methods&.each do |method|
              send method if public_methods(false).include?(method)
            end
          end

          record.save if @options[:record]
        end
      end

      self
    end

    def full_name
      "#{subject.class.name.downcase}.#{name}"
    end

    def subject
      try(:record)&.subject || @subject
    end

    private

    # Event is a singleton and already exists.
    def singleton_exists?
      options[:singleton] && subject.events.active.exists?(name:)
    end
  end
end
