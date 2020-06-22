# frozen_string_literal: true

require 'test_helper'

class StanceTest < Minitest::Test
  def test_has_a_version_number
    refute_nil ::Stance::VERSION
  end
end
