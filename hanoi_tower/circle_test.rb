require "test-unit"
require_relative 'circle'
require_relative 'tower'
require_relative 'game'
class CircleTest < Test::Unit::TestCase

	def test_circle_initialize
		circle = Circle.new(1, Tower.new(1,2))
		assert_equal(circle.size, 1)
		assert_not_nil(circle.actual_tower)
		assert_nil(circle.previous_tower)
		assert (circle.never_played)
		assert_equal(circle.circle_move_count, 0)
		assert_equal(circle.circle_last_move, 0)
		#assert_equal(Circle.moves_count, 0)
	end

	def test_circle_initialize_passing_nil_values
		circle = Circle.new(1)
		assert_equal(circle.size, 1)
		assert_nil(circle.actual_tower)
		assert_nil(circle.previous_tower)
		assert (circle.never_played)
	end

	def test_get_circle_from_circles
		circle = Circle.new(1)
		circles = [Circle.new(1, Tower.new(1,3)), Circle.new(2, Tower.new(2,3)), Circle.new(3, Tower.new(3,3))]
		circle_2 = Circle.new(3)
		assert_equal(circle.get_circle_from_circles(circles).size, circle.size)
		assert_equal(circle_2.get_circle_from_circles(circles).size, circle_2.size)
	end

	#
	# get_circle_position_from_circles
	#
	def test_get_circle_position_from_circles
		circles = [Circle.new(1, Tower.new(1,3)), Circle.new(2, Tower.new(2,3)), Circle.new(3, Tower.new(3,3))]
		circle_1 = circles[2]
		circle_2 = circles[1]
		circle_3 = circles[0]

		assert_equal circle_1.get_circle_position_from_circles(circles, circle_1), 2
		assert_equal circle_1.get_circle_position_from_circles(circles, circle_2), 1
		assert_equal circle_1.get_circle_position_from_circles(circles, circle_3), 0

	end

	#
	# get_circle_position_from_circles_returning_nil
	#
	def test_get_circle_position_from_circles_returning_nil
		circles = [Circle.new(1, Tower.new(1,3)), Circle.new(2, Tower.new(2,3)), Circle.new(3, Tower.new(3,3))]
		circle_1 = Circle.new(4, Tower.new(1,3))

		assert_nil circle_1.get_circle_position_from_circles(circles, circle_1)
		assert_nil circle_1.get_circle_position_from_circles(nil, circle_1)
		assert_nil circle_1.get_circle_position_from_circles([], circle_1)

	end

	#
	# changin_tower
	#
	def test_changin_tower
		tower_1 = Tower.new(1,3)
		tower_2 = Tower.new(2,3)
		tower_3 = Tower.new(3,3)
		circle = Circle.new(1, tower_1)
		#pre validation
		assert_equal(circle.size, 1)
		assert_equal(circle.actual_tower.id, tower_1.id)
		assert_equal(circle.circle_move_count, 0)
		assert_equal(circle.circle_last_move, 0)

		circle.changing_tower(tower_2)

		assert_equal(circle.actual_tower.id, tower_2.id)
		assert_equal(circle.previous_tower.id, tower_1.id)
		assert_equal(circle.circle_move_count, 1)
		assert_equal(circle.circle_last_move, 1)
		assert_equal(Circle.moves_count, 1)
		assert !circle.never_played

		circle.changing_tower(tower_3)

		assert_equal(circle.actual_tower.id, tower_3.id)
		assert_equal(circle.previous_tower.id, tower_2.id)
		assert_equal(circle.circle_move_count, 2)
		assert_equal(circle.circle_last_move, 2)
		assert_equal(Circle.moves_count, 2)

		#circle 2 validation
		circle_2 = Circle.new(2, tower_2)

		circle_2.changing_tower(tower_1)

		assert_equal(circle_2.actual_tower.id, tower_1.id)
		assert_equal(circle_2.previous_tower.id, tower_2.id)
		assert_equal(circle_2.circle_move_count, 1)
		assert_equal(circle_2.circle_last_move, 3)
		assert_equal(Circle.moves_count, 3)
		assert !circle_2.never_played

		#checking globa classes changing
		assert_equal(circle.circle_last_move, 2)
		assert_equal(circle.circle_move_count, 2)
	end

	#
	# is_right_place
	#
	def test_is_right_place
		tower_qtd = 3
		tower = Tower.new(1, tower_qtd)
		tower_2 = Tower.new(2, tower_qtd)
		tower_3 = Tower.new(3, tower_qtd)

		circles = [Circle.new(4, tower, nil), Circle.new(3, tower, nil), Circle.new(2, tower_2, nil), Circle.new(1, tower_2, nil)]
		circle = circles[0]
		#add circle 1
		tower_3.add_circle(circle)
		assert circle.is_right_place(circles)
		circle_2 = circles[1]
		#add circle 2
		tower_3.add_circle(circle_2)
		assert circle_2.is_right_place(circles)

		circle_1 = circles[0]
		assert circle_1.is_right_place(circles)

		circle_3 = circles[2]
		assert !circle_3.is_right_place(circles)
		#add cicle 3
		tower_3.add_circle(circle_3)
		assert circle_3.is_right_place(circles)

		#check circle 2 again
		assert circle_2.is_right_place(circles)

		circle_4 = circles[3]
		assert !circle_4.is_right_place(circles)
	end

	#
	# moved_before
	#
	def test_moved_before
			tower_qtd = 3
			tower = Tower.new(1, tower_qtd)
			tower_2 = Tower.new(2, tower_qtd)
			tower_3 = Tower.new(3, tower_qtd)

			circle_3 = Circle.new(3, tower, nil)
			circle_2 = Circle.new(2, tower, nil)
			circle_1 = Circle.new(1, tower, nil)

			tower_2.add_circle(circle_1)
			tower_3.add_circle(circle_2)

			assert !circle_3.moved_before
			assert !circle_2.moved_before
			# add new circle
			tower_3.add_circle(circle_1)
			assert circle_2.moved_before
	end

	#
	# bigger_one
	#
	def test_bigger_one
		tower_qtd = 3
		tower = Tower.new(1, tower_qtd)
		tower_2 = Tower.new(2, tower_qtd)
		tower_3 = Tower.new(3, tower_qtd)

		circles = [Circle.new(4, tower, nil), Circle.new(3, tower, nil), Circle.new(2, tower_2, nil), Circle.new(1, tower_2, nil)]
		circles =  circles.sort! { |a,b| b.size <=> a.size }
		assert circles[0].bigger_one(circles[0])
		assert !circles[1].bigger_one(circles[0])
		assert !circles[2].bigger_one(circles[0])
	end
end
