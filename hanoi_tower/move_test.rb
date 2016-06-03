require "test-unit"
require_relative 'circle'
require_relative 'tower'
require_relative 'new_game'

class MoveTest < Test::Unit::TestCase

	def setup
		@tower = Tower.new(1, 3)
		@tower_2 = Tower.new(2, 3)
		@circle = Circle.new(1, @tower, nil)		
		@circle_2 = Circle.new(2, @tower_2, nil)
	end

	#
	# initialize
	#
	def test_initialize		
		#first set		
		move = Move.new(@tower, @circle, nil, nil, nil)
		assert_not_nil move.tower
		assert_not_nil move.circle
		assert_equal @circle.size, move.circle.size
		assert_equal @tower.id, move.tower.id
		assert_nil move.next_tower
		assert_nil move.next_circle
		assert_not_empty move.parsed_move
		assert_equal '1!1!!', move.parsed_move

		#second set		
		move = Move.new(nil, nil, @tower_2, @circle_2, nil)
		assert_nil move.tower
		assert_nil move.circle
		assert_equal @circle_2.size, move.next_circle.size
		assert_equal @tower_2.id, move.next_tower.id
		assert_not_nil move.next_tower
		assert_not_nil move.next_circle
		assert_not_empty move.parsed_move
		assert_equal '!!2!2', move.parsed_move

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
		assert_equal move.next_circle.size, @circle_2.size

		assert_equal @circle_2.actual_tower.id, @tower_2.id

		move.does_next_move

		assert_equal @circle_2.actual_tower.id, tower.id
	end

	#
	# load_parsed_game
	#
	def test_load_parsed_game
		circles_length = 3
		towers_length = 3
		game = NewGame.new
		circles = game.load_game(circles_length, towers_length)
		circles[0].initialize_moves_count

		move = Move.new(nil, nil, nil, nil, game)
		assert_not_nil move.parsed_game
		assert_equal '1-3:0:0|2:0:0|1:0:0;2-0:0:0;3-0:0:0@0', move.parsed_game

		move = Move.new(nil, nil, nil, nil, nil)
		assert_nil move.parsed_game
	end

	#
	# parsed_move
	#
	def test_parsed_move
		#first set
		move = Move.new(@tower, @circle, nil, nil, nil)

		assert_not_nil move.parsed_move
		assert_not_empty move.parsed_move
		assert_equal '1!1!!', move.parsed_move

		#second set
		move = Move.new(@tower, @circle, @tower_2, @circle_2, nil)

		assert_not_nil move.parsed_move
		assert_not_empty move.parsed_move
		assert_equal '1!1!2!2', move.parsed_move

		#third set
		move = Move.new(nil, nil, @tower_2, @circle_2, nil)

		assert_not_nil move.parsed_move
		assert_not_empty move.parsed_move
		assert_equal '!!2!2', move.parsed_move

		#fourth set
		move = Move.new(nil, nil, nil, nil, nil)

		assert_not_nil move.parsed_move
		assert_empty move.parsed_move
	end

	#
	# def load_move(parsed_move)
	#
	def test_load_move
		circles_length = 3
		towers_length = 3
		game = NewGame.new
		game.load_game(circles_length, towers_length)
		move = Move.new(game.towers[2], game.game_circles[2], nil, nil, game)

		assert_not_nil move.parsed_move
		assert_equal '2!1!!', move.parsed_move

		assert_equal move.tower.id, game.towers[2].id
		assert_equal move.circle.size, game.game_circles[2].size
		assert_nil move.next_tower
		assert_nil move.next_circle

		new_parsed_move = '3!1!!'
		move.load_move(new_parsed_move)
		
		assert_not_nil move.circle
		assert_not_nil move.tower
		assert_equal 3, move.tower.id
		assert_equal 1, move.circle.size
	end

	#
	# parse_full_game
	#
	def test_parse_full_game
		circles_length = 3
		towers_length = 3
		game = NewGame.new
		game.load_game(circles_length, towers_length)
		move = Move.new(game.towers[2], game.game_circles[2], nil, nil, game)

		parsed_full_game = move.parse_full_game
		assert_not_nil parsed_full_game
		assert_equal '2!1!!*1-3:0:0|2:0:0|1:0:0;2-0:0:0;3-0:0:0@0', parsed_full_game

		move = Move.new(game.towers[3], game.game_circles[1], nil, nil, game)
		move.does_move		
		parsed_full_game = move.parse_full_game

		assert_not_nil move.tower
		assert_not_nil move.circle
		assert_nil move.next_tower
		assert_nil move.next_circle
		assert_not_nil parsed_full_game
		assert_equal '3!2!!*1-3:0:0|1:0:0;2-0:0:0;3-2:1:1@1', parsed_full_game

		move = Move.new(game.towers[3], game.game_circles[2], game.towers[2], game.game_circles[0], game)
		move.does_move
		move.does_next_move		
		parsed_full_game = move.parse_full_game

		assert_not_nil move.tower
		assert_not_nil move.circle
		assert_not_nil move.next_tower
		assert_not_nil move.next_circle
		assert_not_nil parsed_full_game
		assert_equal '3!1!2!3*1-0:0:0;2-3:1:3;3-2:1:1|1:1:2@3', parsed_full_game
	end

	#
	# load_full_game
	#
	def test_load_full_game
	 	full_parsed_game = '1!1!!*1-0:0:0;2-3:1:3;3-2:1:1|1:1:2@3'
	 	move = Move.new(nil, nil, nil, nil, NewGame.new)
	 	move.load_full_game(full_parsed_game)

		assert_not_nil move.tower
		assert_not_nil move.circle
		assert_nil move.next_tower
		assert_nil move.next_circle

		assert_equal 1, move.tower.id
		assert_equal 1, move.circle.size
		assert_empty move.game.towers[1].tower_circles
		assert_equal 3, move.game.towers[2].get_top_circle.size
		assert_equal 2, move.game.towers[3].tower_circles.size
		assert_equal 1, move.game.towers[3].get_top_circle.size

		move.does_move
		assert_not_empty move.game.towers[1].tower_circles
		assert_equal 1, move.game.towers[1].get_top_circle.size
		
  	end
end