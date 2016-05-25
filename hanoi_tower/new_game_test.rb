require "test-unit"
require_relative 'circle'
require_relative 'tower'
require_relative 'new_game'
class NewGameTest < Test::Unit::TestCase

	#
	# game_initialize
	#
	def test_game_initialize
		game = NewGame.new
		assert !game.towers.nil? && game.towers.empty?
		assert !game.game_circles.nil? && game.game_circles.empty?
		assert game.actual_move == 0
	end

	#
	# load_towers
	#
	def test_load_towers
		game = NewGame.new
		towers = game.load_towers(3)
		assert_not_nil(towers)
		assert_not_empty(towers)
		assert_equal(towers.size, 3)
		assert_equal(towers[1].towers_max, 3)
		assert_equal(towers[2].id, 2)
		assert_equal(towers[3].id, 3)
	end

	#
	# load_game
	#
	def test_load_game
		circles_length = 3
		towers_length = 3
		game = NewGame.new
		circles = game.load_game(circles_length, towers_length)
		assert_not_nil(circles)
		assert_not_empty(circles)
		assert_equal(circles.size, circles_length)
		assert_equal(circles[0].size, 3)

		assert_equal(circles[0].actual_tower.id, game.towers[1].id)
		assert_equal(circles[1].actual_tower.id, game.towers[1].id)
		assert_equal(circles[2].actual_tower.id, game.towers[1].id)

		assert_nil circles[0].previous_tower
		assert_nil circles[1].previous_tower
		assert_nil circles[2].previous_tower

		assert_equal(circles[circles.size - 1].size, 1)
		assert_equal(game.towers[1].tower_circles.size, circles.size)
		assert_equal(game.towers.size, towers_length)
		assert_equal(game.towers[1].tower_circles[0].size, circles[0].size)
		assert_equal(game.towers[1].get_top_circle.size , 1)
	end

	#
	# get_all_towers_available
	#
	def test_get_all_towers_available
		circles_length = 3
		towers_length = 3
		game = NewGame.new
		circles = game.load_game(circles_length, towers_length)
		towers = game.get_all_towers_available

		assert_not_empty towers
		assert_equal 3, towers.size
		assert_not_nil towers
	end

	#
	# get_all_towers_available
	#
	def test_get_destiny_tower
		circles_length = 3
		towers_length = 4
		game = NewGame.new
		circles = game.load_game(circles_length, towers_length)
		
		tower = game.get_destiny_tower(game.towers)

		assert_not_nil tower
		assert_equal 4, tower.id
		assert_empty tower.tower_circles
	end


	#
	# get_all_top_circles
	#
	def test_get_all_top_circles
		circles_length = 3
		towers_length = 3
		game = NewGame.new
		circles = game.load_game(circles_length, towers_length)
		
		circles = game.get_all_top_circles

		assert_not_nil circles
		assert_not_empty circles
		assert_equal 1, circles.size

		game.towers[2].change_circle game.game_circles[2]

		circles = game.get_all_top_circles

		assert_not_nil circles
		assert_not_empty circles
		assert_equal 2, circles.size
		assert_equal 2, circles[0].size
		assert_equal 1, circles[1].size

	end

	#
	# contains_circles_by_size
	#
	def test_contains_circles_by_size
		circles_length = 3
		towers_length = 3
		game = NewGame.new
		circles = game.load_game(circles_length, towers_length)

		assert game.contains_circles_by_size(circles, 2)
		assert game.contains_circles_by_size(circles, 1)
		assert game.contains_circles_by_size(circles, 3)

		circles.pop

		assert game.contains_circles_by_size(circles, 2)
		assert !game.contains_circles_by_size(circles, 1)
		assert game.contains_circles_by_size(circles, 3)

		circles.pop

		assert !game.contains_circles_by_size(circles, 2)
		assert !game.contains_circles_by_size(circles, 1)
		assert game.contains_circles_by_size(circles, 3)
	end

	#
	# get_all_tower_with_empty_circles
	#
	def test_get_all_tower_with_empty_circles
		circles_length = 3
		towers_length = 3
		game = NewGame.new
		game.load_game(circles_length, towers_length)

		towers = game.get_all_tower_with_empty_circles(game.towers, true)

		assert_not_empty towers
		assert_equal 2, towers.size
		assert_equal 2, towers[0].id

		towers = game.get_all_tower_with_empty_circles(game.towers, false)

		assert_not_empty towers
		assert_equal 1, towers.size


		game.towers[2].change_circle game.game_circles[2]

		towers = game.get_all_tower_with_empty_circles(game.towers, true)

		assert_not_empty towers
		assert_equal 1, towers.size
		assert_equal 3, towers[0].id

		towers = game.get_all_tower_with_empty_circles(game.towers, false)

		assert_not_empty towers
		assert_equal 2, towers.size
		assert_equal 1, towers[0].id
		assert_equal 2, towers[1].id

	end

	#
	# get_towers_available_from_circle
	#
	def test_get_towers_available_from_circle
		circles_length = 3
		towers_length = 3
		game = NewGame.new
		circles = game.load_game(circles_length, towers_length)
		towers = game.get_towers_available_from_circle(game.towers, circles[2])

		assert_empty towers

		game.towers[2].change_circle game.game_circles[2]

		towers = game.get_towers_available_from_circle(game.towers, circles[2])

		assert_not_empty towers
		assert_equal 1, towers[0].id
		assert_equal 1, towers.size

		game.towers[3].change_circle game.game_circles[1]

		towers = game.get_towers_available_from_circle(game.towers, circles[2])

		assert_not_empty towers
		assert_equal 1, towers[0].id
		assert_equal 2, towers.size

		towers = game.get_towers_available_from_circle(game.towers, circles[1])

		assert_not_empty towers
		assert_equal 1, towers[0].id
		assert_equal 1, towers.size
	end

	#
	# do_get_availables_circles
	#
	def test_do_get_availables_circles
		circles_length = 3
		towers_length = 3
		game = NewGame.new
		game.load_game(circles_length, towers_length)

		game.towers[2].change_circle game.game_circles[2]

		circles = game.do_get_availables_circles true

		assert_not_empty circles
		assert_equal 1, circles.size
		assert_equal 2, circles[0].size

		circles = game.do_get_availables_circles false

		assert_not_empty circles
		assert_equal 2, circles.size
		assert_equal 2, circles[0].size
		assert_equal 1, circles[1].size

		game.towers[3].change_circle game.game_circles[1]
		game.towers[3].change_circle game.game_circles[2]

		circles = game.do_get_availables_circles true

		assert_not_empty circles
		assert_equal 1, circles.size
		assert_equal 3, circles[0].size
		
		circles = game.do_get_availables_circles false

		assert_not_empty circles
		assert_equal 2, circles.size
		assert_equal 3, circles[0].size
		assert_equal 1, circles[1].size

	end

	#
	# get_availables_circles
	#
	def test_get_availables_circles
		circles_length = 4
		towers_length = 4
		game = NewGame.new
		game.load_game(circles_length, towers_length)

		circles = game.get_availables_circles
		
		assert_not_empty circles
		assert_equal 1, circles.size
		assert_equal 1, circles[0].size

		game.towers[2].change_circle game.game_circles[2]

		circles = game.get_availables_circles
		
		assert_not_empty circles
		assert_equal 1, circles.size
		assert_equal 1, circles[0].size

		game.towers[3].change_circle game.game_circles[0]

		circles = game.get_availables_circles
		
		assert_not_empty circles
		assert_equal 2, circles.size
		assert_equal 1, circles[0].size
		assert_equal 2, circles[1].size

	end

	#
	# treat_destiny_towers
	#
	def test_treat_destiny_towers
		circles_length = 4
		towers_length = 4
		game = NewGame.new
		circles = game.load_game(circles_length, towers_length)

		circles_temp = [circles[2], circles[1]]
		move =  game.treat_destiny_towers(game.towers, circles_temp)
		assert_nil move

		circles_temp = [circles[2], circles[0]]
		move =  game.treat_destiny_towers(game.towers, circles_temp)
		assert_not_nil move
		assert_equal 3, move.tower.id
		assert_equal 3, move.circle.size

	end


end