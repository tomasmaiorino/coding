require "test-unit"
require_relative 'circle'
require_relative 'tower'
require_relative 'game'
class TowerTest < Test::Unit::TestCase

	def test_tower_initialize
		tower = Tower.new(1, 3)
		assert_equal(tower.id, 1)
		assert_empty(tower.circles)
		assert_equal(tower.towers_max, 3)
	end

	def test_tower_is_destiny
		tower = Tower.new(3, 3)
		assert tower.is_destiny

		tower = Tower.new(4, 4)
		assert tower.is_destiny
	end

	def test_tower_is_not_destiny
		tower = Tower.new(2, 3)
		assert !tower.is_destiny
	end

	def test_get_top_circle
		tower = Tower.new(1, 3)
		tower_2 = Tower.new(2,2)
		circles = [Circle.new(1, tower), Circle.new(2, tower_2), Circle.new(3, Tower.new(3,3))]
		tower.circles = circles
		assert_equal(tower.get_top_circle.size, 3)

		tower_circles = tower_2.add_circle(circles[0])
		assert_equal(tower_2.get_top_circle.size, circles[0].size)
		assert_equal(tower_circles, 1)

		tower_circles = tower_2.add_circle(circles[1])
		assert_equal(tower_2.get_top_circle.size, circles[1].size)
		assert_equal(tower_circles, 2)

		tower_circles = tower_2.add_circle(circles[2])
		assert_equal(tower_2.get_top_circle.size, circles[2].size)
		assert_equal(tower_circles, 3)

	end

	def test_get_bottom_circle
		tower = Tower.new(3, 3)
		circles = [Circle.new(3, Tower.new(3,3))]
		tower.circles = circles
		assert_equal(tower.get_bottom_circle.size, 3)
	end

	def test_add_circle
		tower_3 = Tower.new(3, 3)
		tower_2 = Tower.new(2, 3)
		circle = Circle.new(1, tower_2, nil)
		circles_length = tower_3.add_circle(circle)
		# checking circle changes
		assert_equal(circles_length, 1)
		assert_equal(circle.actual_tower.id, tower_3.id)
		assert_equal(circle.previous_tower.id, tower_2.id)
		assert_equal(circle.circle_move_count, 1)
		#assert_equal(circle.circle_last_move, 1)
		assert_equal(Circle.moves_count, circle.circle_last_move)

		assert_equal(tower_3.get_bottom_circle.size, circle.size)
	end
end
