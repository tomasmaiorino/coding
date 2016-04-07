require "test-unit"
require_relative 'circle'
require_relative 'tower'
require_relative 'game'
class CircleTest < Test::Unit::TestCase

	def test_circle_initialize
		circle = Circle.new(1, Tower.new(1,2))
		assert_equal(circle.size, 1)
		assert_not_nil(circle.actual_tower)
		assert_empty(circle.last_tower)
		assert (circle.never_played)
	end

	def test_circle_initialize_passing_nil_values
			circle = Circle.new(1)
			assert_equal(circle.size, 1)
			assert_nil(circle.actual_tower)
			assert_empty(circle.last_tower)
			assert (circle.never_played)
		end
end
