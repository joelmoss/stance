# frozen_string_literal: true

require 'rails'

module Stance
  class Engine < ::Rails::Engine
    isolate_namespace Stance
  end
end
