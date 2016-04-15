require "test-unit"
require_relative 'circle'
require_relative 'tower'
require_relative 'game'
class TowerTest < Test::Unit::TestCase

	def test_tower_initialize
		tower = Tower.new(1, 3)
		assert_equal(tower.id, 1)
		assert_empty(tower.tower_circles)
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
		circles = [Circle.new(3, tower), Circle.new(2, tower_2), Circle.new(1, Tower.new(3,3))]
		tower.tower_circles = circles
		assert_equal(tower.get_top_circle.size, 1)

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
		tower.tower_circles = circles
		assert_equal(tower.get_bottom_circle.size, 3)
	end

	def test_add_circle
		tower_3 = Tower.new(3, 3)
		tower_2 = Tower.new(2, 3)
		circle_1 = Circle.new(1, tower_2, nil)
		circle_2 = Circle.new(2, tower_2, nil)
		circle_3 = Circle.new(3, tower_2, nil)
		#add circle 3
		circles_length = tower_3.add_circle(circle_3)
		# checking circle changes
		assert_equal(circles_length, 1)
		assert_equal(circle_3.actual_tower.id, tower_3.id)
		assert_equal(circle_3.previous_tower.id, tower_2.id)
		assert_equal(circle_3.circle_move_count, 1)

		assert_equal(Circle.moves_count, circle_3.circle_last_move)
		assert_equal(tower_3.get_bottom_circle.size, circle_3.size)

		#add circle 2
		circles_length = tower_3.add_circle(circle_2)
		# checking circle changes
		assert_equal(circles_length, 2)
		assert_equal(circle_2.actual_tower.id, tower_3.id)
		assert_equal(circle_2.previous_tower.id, tower_2.id)
		assert_equal(circle_2.circle_move_count, 1)

		assert_equal(Circle.moves_count, circle_2.circle_last_move)

		#add circle 1
		circles_length = tower_3.add_circle(circle_1)
		# checking circle changes
		assert_equal(circles_length, 3)
		assert_equal(circle_1.actual_tower.id, tower_3.id)
		assert_equal(circle_1.previous_tower.id, tower_2.id)
		assert_equal(circle_1.circle_move_count, 1)

		assert_equal(Circle.moves_count, circle_1.circle_last_move)

		assert_equal(tower_3.tower_circles[0].size, circle_3.size)
		assert_equal(tower_3.tower_circles[1].size, circle_2.size)
		assert_equal(tower_3.tower_circles[2].size, circle_1.size)
	end

	def test_remove_circle
		tower_2 = Tower.new(2, 3)
		circle_1 = Circle.new(1, tower_2, nil)
		circle_2 = Circle.new(2, tower_2, nil)
		circle_3 = Circle.new(3, tower_2, nil)

		tower_2.add_circle(circle_3)
		tower_2.add_circle(circle_2)
		tower_2.add_circle(circle_1)


		#checking tower's circles length
		assert_equal tower_2.tower_circles.size, 3
		#checking if the circle_2 still belongs to tower's circles
		assert_not_nil tower_2.tower_circles[0].get_circle_position_from_circles(tower_2.tower_circles, circle_2)
		#removed circle_2 from tower_2
		removed_circle = tower_2.remove_circle(circle_2)

		assert_equal removed_circle.size, circle_2.size
		#check if circle_2 doesn't belong to tower_2 anymore
		assert_nil tower_2.tower_circles[0].get_circle_position_from_circles(tower_2.tower_circles, circle_2)
		#check the new tower_2's length
		assert_equal tower_2.tower_circles.size, 2

		#checking if the circle_2 still belongs to tower's circles
		assert_not_nil tower_2.tower_circles[0].get_circle_position_from_circles(tower_2.tower_circles, circle_3)
		#removed circle_3 from tower_2
		removed_circle = tower_2.remove_circle(circle_3)
		assert_equal removed_circle.size, circle_3.size

		#check the new tower_2's length
		assert_equal tower_2.tower_circles.size, 1
	end

end
