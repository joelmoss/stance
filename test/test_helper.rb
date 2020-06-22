# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'bundler/setup'
require 'stance'
require 'combustion'
require 'minitest/autorun'

Combustion.path = 'test/internal'
Combustion.initialize! :active_record
