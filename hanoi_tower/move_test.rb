require "test-unit"
require_relative 'circle'
require_relative 'tower'
require_relative 'new_game'

class MoveTest < Test::Unit::TestCase

	def setup
		@tower = Tower.new(1, 3)
		@tower_2 = Tower.new(2, 3)
		@circle = Circle.new(1, @tower, nil)		
		@circle_2 = Circle.new(1, @tower_2, nil)
	end

	#
	# initialize
	#
	def test_initialize
		tower = Tower.new(1, 3)
		tower_2 = Tower.new(2, 3)
		circle = Circle.new(1, tower)
		circle_2 = Circle.new(1, tower_2)
		
		#first set		
		move = Move.new(tower, circle, nil, nil, nil)
		assert_not_nil move.tower
		assert_not_nil move.circle
		assert_equal circle.size, move.circle.size
		assert_equal tower.id, move.tower.id
		assert_nil move.next_tower
		assert_nil move.next_circle
		assert_empty move.parsed_move

		#second set		
		move = Move.new(nil, nil, tower_2, circle_2, nil)
		assert_nil move.tower
		assert_nil move.circle
		assert_equal circle_2.size, move.next_circle.size
		assert_equal tower_2.id, move.next_tower.id
		assert_not_nil move.next_tower
		assert_not_nil move.next_circle
		assert_empty move.parsed_move

	end

	#
	# has_next_move
	#
	def test_has_next_move
		move = Move.new(@tower, @circle, nil, nil, nil)
		assert !move.has_next_move

		move = Move.new(nil, nil, @tower_2, @circle_2, nil)
		assert move.has_next_move
	end

	#
	# does_move
	#
	def test_does_move
		tower = Tower.new(3, 3)		
		@tower.add_circle(@circle)

		move = Move.new(tower, @circle, nil, nil, nil)
		
		assert_equal move.tower.id, tower.id
		assert_nil move.tower.get_top_circle
		assert_equal move.circle.size, @circle.size

		assert_equal @circle.actual_tower.id, @tower.id

		move.does_move		

		assert_equal @circle.actual_tower.id, tower.id
	end

	#
	# does_next_move
	#
	def test_does_next_move
		tower = Tower.new(3, 3)
		@tower_2.add_circle(@circle_2)

		
		move = Move.new(nil, nil, tower, @circle_2, nil)
		assert_equal move.next_tower.id, tower.id
		assert_nil move.next_tower.get_top_circle
		assert_equal move.next_circle.size, @circle.size

		assert_equal @circle_2.actual_tower.id, @tower_2.id

		move.does_next_move

		assert_equal @circle_2.actual_tower.id, tower.id
	end


end