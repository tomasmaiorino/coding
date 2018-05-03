require "test-unit"
require_relative 'circle'
require_relative 'tower'
require_relative 'new_game'

class FullGameTest < Test::Unit::TestCase

	#
	#
	#
	def test_game_test_three_towers_three_circles
		circles_length = 3
		towers_length = 3
		game = NewGame.new
		circles = game.load_game(circles_length, towers_length)
		circles[0].initialize_moves_count

		move = game.move(nil)
		while !move.game.finished
			parsed_game = move.parse_full_game
			move.load_full_game(parsed_game)
			move = game.move(move)
		end
		assert_equal 7, move.moves_count
		assert_equal 'done', move.parsed_move
	end

	#
	#
	#
	def test_game_test_three_towers_four_circles
		circles_length = 4
		towers_length = 3
		game = NewGame.new
		circles = game.load_game(circles_length, towers_length)
		circles[0].initialize_moves_count

		move = game.move(nil)
		while !move.game.finished
			parsed_game = move.parse_full_game
			move.load_full_game(parsed_game)
			move = game.move(move)
		end
		assert_equal 30, move.moves_count
		assert_equal 'done', move.parsed_move
	end

	#
	# full test
	#
	def test_full_game
		circles_length = 3
		towers_length = 3
		game = NewGame.new
		circles = game.load_game(circles_length, towers_length)
		circles[0].initialize_moves_count
		#first move
		#circle 1 tower 3
		move = game.move(nil)

		assert_equal 1, move.circle.size
		assert_equal 3, move.tower.id
		assert_equal 1, move.circle.actual_tower.id

		parsed_game = move.parse_full_game

		assert_not_empty parsed_game
		assert_equal '3!1!!*1-3:0:0|2:0:0|1:0:0;2-0:0:0;3-0:0:0@0', parsed_game

		move.load_full_game(parsed_game)
		
		move = game.move(move)

		assert_equal 1, move.circle.actual_tower.id
		assert_equal 2, move.tower.id
		assert !game.finished

		parsed_game = move.parse_full_game
		
		assert_not_empty parsed_game
		assert_equal '2!2!!*1-3:0:0|2:0:0;2-0:0:0;3-1:1:1@1', parsed_game

		move.load_full_game(parsed_game)

		move = game.move(move)

		assert_equal 3, move.circle.actual_tower.id
		assert_equal 2, move.tower.id
		assert !game.finished

		parsed_game = move.parse_full_game
		
		assert_not_empty parsed_game
		assert_equal '2!1!!*1-3:0:0;2-2:1:2;3-1:1:1@2', parsed_game

		move.load_full_game(parsed_game)

		move = game.move(move)

		assert_equal 1, move.circle.actual_tower.id
		assert_equal 3, move.tower.id
		assert !game.finished

		parsed_game = move.parse_full_game
		
		assert_not_empty parsed_game
		assert_equal '3!3!!*1-3:0:0;2-2:1:2|1:2:3;3-0:0:0@3', parsed_game

		move.load_full_game(parsed_game)

		move = game.move(move)

		assert_equal 2, move.circle.actual_tower.id
		assert_equal 1, move.tower.id
		assert_equal 2, move.next_circle.actual_tower.id
		assert_equal 3, move.next_tower.id		
		assert !game.finished

		parsed_game = move.parse_full_game
		assert_not_empty parsed_game
		assert_equal '1!1!3!2*1-0:0:0;2-2:1:2|1:2:3;3-3:1:4@4', parsed_game

		move = game.move(move)
		assert_equal 1, move.circle.actual_tower.id
		assert_equal 3, move.tower.id
		assert !game.finished

		parsed_game = move.parse_full_game
		
		assert_not_empty parsed_game
		assert_equal '3!1!!*1-1:3:5;2-0:0:0;3-3:1:4|2:2:6@6', parsed_game

		move.load_full_game(parsed_game)

		move = game.move(move)
		assert game.finished
		
		parsed_game = move.parse_full_game
		
		assert_not_empty parsed_game
		assert_equal 'done*1-0:0:0;2-0:0:0;3-3:1:4|2:2:6|1:4:7@7', parsed_game

	end

end