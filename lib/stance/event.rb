# frozen_string_literal: true

module Stance
  class Event
    include ActiveSupport::Callbacks

    define_callbacks :create
    attr_reader :record, :options, :name

    class << self
      attr_accessor :callback_methods

      def before_create(*methods, &block)
        set_callback :create, :before, *methods, &block
      end

      def after_create(*methods, &block)
        set_callback :create, :after, *methods, &block
      end

      def method_added(method_name)
        return if self == Stance::Event

        puts "Adding #{self}##{method_name.inspect}"

        self.callback_methods ||= []
        self.callback_methods << method_name
      end
    end

    def initialize(name, subject, metadata, options)
      @subject = subject
      @name = name
      @metadata = metadata
      @options = { singleton: false, record: true, class: false }.merge(options)

      attrs = { name: name, metadata: metadata }
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

            self.class.callback_methods.each { |method| send method }
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
      options[:singleton] && subject.events.active.exists?(name: name)
    end
  end
end
