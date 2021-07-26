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
      @options = { singleton: false, record: true, class: false }.merge(options)

      attrs = { name: name, metadata: metadata }
      if subject.is_a?(String)
        attrs[:subject_type] = subject
      else
        attrs[:subject] = subject
      end
      @record = Stance::EventRecord.new(attrs)
    end

    def create
      return self if singleton_exists?

      Stance::EventRecord.transaction do
        run_callbacks :create do
          # Call each public method of the Event class if a custom class.
          if self.class.name != 'Stance::Event'
            Rails.logger.info "Event: #{full_name}"

            (public_methods(false) - Stance::Event.instance_methods(false)).each do |method|
              send method
            end
          end

          record.save if @options[:record]
        end
      end

      self
    end

    def full_name
      "#{record.subject_type.downcase}.#{name}"
    end

    private

    # Event is a singleton and already exists.
    def singleton_exists?
      options[:singleton] && subject.events.active.exists?(name: name)
    end
  end
end
